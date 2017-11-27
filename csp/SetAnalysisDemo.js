//Define angular modules for our app

var conceptsApp = angular.module('conceptsApp', ['ngSanitize']);

 conceptsApp.controller('DomainController', ['$scope', function($scope) {
	 
	 // initialize ikDomain
	function initDomain() {
		var domain = location.search.substr(1).split('#')[0];
		if (!isNaN(parseInt(domain))) return parseInt(domain);
		var regexp = /^([0-9]+)/;
		var parsed = regexp.exec(domain);
		if (parsed && (parsed.length>0) && !isNaN(parseInt(parsed[0]))) return parsed[0];
		alert('No domain specified in URL!'); 
		return 0;
	}
	$scope.ikDomain = initDomain();
	 
	// retrieve capabilities
   	function getFeatures() {
	   	$.get(hostURL($scope.ikDomain) + "Features",
			   	function(data) {
			    	$scope.Features = data;
		        });
   	}
   	getFeatures();
   	
 }]);

 hostURL = function(domain) {
	 if (!domain) { domain = ':domain'; }
	 return location.href.split('/').slice(0,-1).join('/')+'/saREST/Domain/'+domain+'/';
 };
 
  $('#myTabs a').click(function (e) {
    e.preventDefault();
    $(this).tab('show')
  })
   
 
  
 conceptsApp.controller('ConceptsController', ['$scope', function($scope) {
	 
   $scope.getSets = function() {
     $scope.selectedSet = '';
     $.get(hostURL($scope.ikDomain)+'Sets/Info', function(data) {
	     $scope.totalInSets = data.TotalInSets;
	     $scope.totalNotInSets = data.TotalNotInSets;
	     $scope.totalSources = data.TotalSources;
	     $scope.sets = data.Sets;
	     var maxSetSize = 0;
	     for (var i = 0; i < data.Sets.length; i++) {
		     if (maxSetSize < data.Sets[i].Sources) maxSetSize = data.Sets[i].Sources;
	     }
	     $scope.totalSourcesDenominator = (maxSetSize < (0.6 * data.TotalSources)) ? ((maxSetSize > 0) ? (maxSetSize * 1.3) : 1) : data.TotalSources;
		 $scope.$apply();
      });
   }

   $scope.editSet= function(set, index) {
	   $scope.SetId = set.SetId;
	   $scope.SetName = set.Name;
	   $scope.SetLogic = set.Logic
	   
	   if ((set.Logic != '') && (set.Logic != null)) {
		 $('#newSetModal').modal();
	   } else {
		 // move all Entities into the Similar table
		 $scope.similar = new Array();
		 for (i in set.Entities) {
			$scope.similar[$scope.similar.length] = { EntityValue: set.Entities[i], selected: 1, canRemove: true }; 
		 }
		 $scope.crcs = new Array();
		 for (i in set.CRCs) {
			$scope.crcs[$scope.crcs.length] = { Value: set.CRCs[i], selected: 1, canRemove: true }; 
		 }
		$('#myTabs li:eq(1) a').tab('show');
	  }
  }
  
  $scope.removeFromSet = function(type, obj) {
	 obj.canRemove = false;
	 obj.selected = 0;
	 req = {'SetId': $scope.SetId, 'Name':$scope.SetName, 'Type':type };
	 if (type == 'entity') {
		 req.Value = obj.EntityValue; 
	 } else {
		 req.Value = obj.Value;
	 }
	 
	  $.ajax({
	  		url: hostURL($scope.ikDomain)+'Sets/Update',
	  		method: 'POST',
	  		contentType: 'application/json; charset=UTF-8',
	  		data: JSON.stringify( req ),
  			complete: function(data) {
	      		$scope.getSets();
       		}
	  });
  }

   $scope.deleteSet= function(set, index) {
	  $.ajax({
	  		url: hostURL($scope.ikDomain)+'Sets/Delete',
	  		method: 'POST',
	  		contentType: 'application/json; charset=UTF-8',
	  		data: JSON.stringify({ SetId: set.SetId }),
  			complete: function(data) {
	      		$scope.getSets();
       		}
	  });
  }
  
  $scope.isSelectedSet = function(set) {
    return (set.SetId == $scope.selectedSet)
  };
  
  $scope.selectSet =  function(set, index) {
	$scope.selectedSet = set.SetId;
	
    $scope.showSourcesBySet(set);
    
    $.get(hostURL($scope.ikDomain)+'Sets/Overlaps/'+set.SetId, function(data) {
     // for each set in overlap, update $scope.sets.Overlap 
     var overlapLength = data.Overlaps.length;
     var setLength = $scope.sets.length
     for (var j = 0; j < setLength; j++) {
	    $scope.sets[j].Overlap = '';
	    $scope.sets[j].OverlapSet = '';
	    if ($scope.sets[j].SetId == set.SetId) continue;
	    
	    for (var i = 0; i < overlapLength; i++) {
          if (data.Overlaps[i].SetId == $scope.sets[j].SetId) {
	      	$scope.sets[j].Overlap = data.Overlaps[i].Count;
	      	$scope.sets[j].OverlapSet = set;
	      }
       }
     }
	 $scope.$apply();
    });
  }
  
  $scope.showSourcesBySet = function(set1, set2) {
    if (set2 == undefined) {
	  	$scope.overlapSourcesRole = 'Sources in set \''+set1.Name+'\'';
	  	$.get(hostURL($scope.ikDomain)+'Sources/Set/'+set1.SetId, function(data) {
      		$scope.overlapSources = data.Sources;
			$scope.$apply();
    	});
    } else {
	    $scope.overlapSourcesRole = 'Overlapping sources for sets \''+set1.Name+'\' and \''+set2.Name+'\'';
    	$.get(hostURL($scope.ikDomain)+'Sources/Set/'+set1.SetId+'/'+set2.SetId, function(data) {
      		$scope.overlapSources = data.Sources;
			$scope.$apply();
    	});
    }
  }
  
  $scope.overlapSourcesRole = 'Sources in set';

   $scope.panelVisible = false;
   
   // initial populate of sets tab
   $scope.getSets(); 
   
   
   $scope.clearForm = function() {
     $scope.SetId = '';
     $scope.SetName = '';
   }
   $scope.clearForm();
   
   $scope.refreshConcepts = function() {
	  $.ajax({
	  		url: hostURL($scope.ikDomain)+'Entities',
	  		method: 'POST',
	  		contentType: 'application/json; charset=UTF-8',
	  		data: JSON.stringify({ 
 	 			filter: $scope.filterSet, 
  				blacklists: $scope.selectedBlacklists
  			}),
  			success: function(data) {
	      		$scope.concepts = data.Entities;
			    $scope.$apply();
       		}
	  });
      
      if ($scope.autocomplete) {
	      $scope.getSimilar($scope.autocomplete);
		  $scope.getCRCs($scope.autocomplete);
      }
   }
         
   $scope.getSimilar = function (conceptValue) {
	  $.ajax({
	  		url: hostURL($scope.ikDomain)+'Entities',
	  		method: 'POST',
	  		contentType: 'application/json; charset=UTF-8',
	  		data: JSON.stringify({ 
	  			entity: conceptValue,
 	 			filter: $scope.filterSet, 
  				blacklists: $scope.selectedBlacklists
  			}),
  			success: function(data) {
	      		$scope.similar = data.Entities;
			    //$scope.$apply();
       		}
	  });
   };
   
   $scope.getCRCs = function (entityValue) {
	  $.ajax({
	  		url: hostURL($scope.ikDomain)+'CRCs',
	  		method: 'POST',
	  		contentType: 'application/json; charset=UTF-8',
	  		data: JSON.stringify({ 
	  			entity: entityValue,
 	 			filter: $scope.filterSet
  			}),
  			success: function(data) {
	      		$scope.crcs = data.CRCs;
			    $scope.$apply();
       		}
	  });
   };
   
   $scope.getSentences = function (type, value) {
	  $.ajax({
	  		url: hostURL($scope.ikDomain)+'Sentences',
	  		method: 'POST',
	  		contentType: 'application/json; charset=UTF-8',
	  		data: JSON.stringify({ 
	  			type: type,
	  			value: value,
 	 			filter: $scope.filterSet
  			}),
  			success: function(data) {
	      		$scope.sentences = data.Sentences;
			    $scope.$apply();
       		}
	  });
   };
   
   $scope.selectConcept = function (concept) {
	 $scope.autocomplete = '';
     $scope.clearForm();
	 $scope.getSimilar(concept.EntityValue);
	 $scope.getCRCs(concept.EntityValue);
	 $scope.getSentences('entity', concept.EntityValue);
   };
  
   $scope.isSelected = function (index, type) {
	   if (type == 'entity') {
	   	   return $scope.similar[index].selected;
	   } else {
		   return $scope.crcs[index].selected;
	   }
   }
   

   $scope.isWarning = function (value) {
   	 return (value>0);
   }

   $scope.selectSimilar = function (concept, index) {
	 if (!$scope.similar[index].canRemove) {
		 // if not in set-editing mode, un/select
		 $scope.similar[index].selected = !$scope.similar[index].selected;
	 }
	 $scope.getSentences('entity', concept.EntityValue);
   };


	$scope.selectCRC = function (crc, index) {
		if (!crc.canRemove) {
			crc.selected = !crc.selected;
		}
		$scope.getSentences('crc', crc.Value);
	};
    
  $scope.exploreKey = function(event) {
	if (event && ((event.keyCode==13) || (event.which==13))) {
		$scope.explore();
	}
  }
  
  $scope.toggleBL = function(id) {
	 var index = $scope.selectedBlacklists.indexOf(id);
	 if (index < 0) {
		 $scope.selectedBlacklists.push(id);
	 } else {
		 var x = $scope.selectedBlacklists.slice(0,index);
		 $scope.selectedBlacklists = x.concat($scope.selectedBlacklists.slice(index+1));
	 }
	 $scope.refreshConcepts();
	 $scope.getSentiment();
  }
  $scope.selectedBlacklists = [];
  
  $scope.explore = function() {
    if (($scope.autocomplete != '') && ($scope.autocomplete.length >= $scope.Features.MinSearchLength)) {
	    $scope.getSimilar($scope.autocomplete);
	    $scope.getCRCs($scope.autocomplete);
    }
  };
  
  
  $scope.saveSet = function(name) {
	var ents = [];
    for (var i in $scope.similar) {
  	  if ($scope.similar[i].selected) {
        ents.push($scope.similar[i].EntityValue);
      }
    }
    var crcs = [];
    for (var i  in $scope.crcs) {
	   if ($scope.crcs[i].selected) {
		    crcs.push($scope.crcs[i].Value);
	   }
    }
    
	  $.ajax({
	  		url: hostURL($scope.ikDomain)+'Sets/Save',
	  		method: 'POST',
	  		contentType: 'application/json; charset=UTF-8',
	  		data: JSON.stringify({ 
	  			SetId: $scope.SetId,
 	 			Name: name, 
  				Entities: ents,
  				CRCs: crcs
  			}),
  			complete: function(data) {
	      		$scope.getSets();
       		}
	  });
	  
  }
  
   // initial populate of concepts table
   $scope.refreshConcepts();
   
   
	  
	  $scope.getSentiment = function() {
		  $.ajax({
		  		url: hostURL($scope.ikDomain)+'Sentiment',
		  		method: 'POST',
		  		contentType: 'application/json; charset=UTF-8',
		  		data: JSON.stringify({ 
	  				blacklists: $scope.selectedBlacklists
	  			}),
	  			success: function(data) {
				  $scope.sentimentData = data.Entities;
				  $scope.hasSentimentData = (data.Entities.length>0);
				  $scope.$apply();
	       		}
		  });
	  };
	  
	  $scope.getSentiment();
	  
	  this.sortField = 'TotalFrequency';
	  this.reverse = true;
	  
	  this.sort = function (fieldName) {
		  if (this.sortField === fieldName) {
		    this.reverse = !this.reverse;
		  } else {
		    this.sortField = fieldName;
		    this.reverse = (fieldName != 'EntityValue');
		  }
	  };
	  
	  this.isSortUp = function (fieldName) {
		  return this.sortField === fieldName && !this.reverse;
	  };
	         
	  this.isSortDown = function (fieldName) {
		  return this.sortField === fieldName && this.reverse;
	  };
	  
	  this.sentimentClass = function (entity) {
		  if ((entity.TotalNegative==0) && (entity.TotalPositive>0)) { return 'text-success'; }
		  if ((entity.TotalNegative>0) && (entity.TotalPositive>0)) { return 'text-warning'; }
		  if ((entity.TotalNegative>0) && (entity.TotalPositive==0)) { return 'text-danger'; }
		  
		  return '';
	  }
	  
	  $scope.sentFilterAtt = '';
	  $scope.sentenceCriteria = { };
	  
	  $scope.selectSentimentFilter = function (att) {
		  $scope.sentFilterAtt=att;
		  switch (att) {
			  case '': $scope.sentenceCriteria = { }; break;
			  case 'pos': $scope.sentenceCriteria = { HasPositive: 1 }; break;
			  case 'neg': $scope.sentenceCriteria = { HasNegative: 1 }; break;
		  }
	  }
	  
	  $scope.newCompositeSet = function() {
		  $scope.SetId = 0;
		  $scope.SetName = '';
		  $scope.SetLogic = '';
		  $('#newSetModal').modal();
	  }
	  
	  $scope.saveCompositeSet = function() {
		
		  $.ajax({
		  		url: hostURL($scope.ikDomain)+'Sets/Save',
		  		method: 'POST',
		  		contentType: 'application/json; charset=UTF-8',
		  		data: JSON.stringify({ 
		  			SetId: $scope.SetId,
	 	 			Name: $scope.SetName, 
	  				Logic: $scope.SetLogic
	  			}),
	  			complete: function(data) {
					$('#newSetModal').modal('hide');
		      		$scope.getSets();
	       		}
		  });
	  };
	  
	  $scope.selectedSource = "";
	  $scope.selectSource = function(srcId) {
		  $.get(hostURL($scope.ikDomain)+'Sources/'+srcId, function(data) {
			  $scope.selectedSource = data;
		  	  $('#fullSourceModal').modal('show');
		  });
	  };
 }]);

   
	  
 conceptsApp.controller('SourceController', ['$scope', function($scope) {
	  
	  this.getSources = function() {
		$.get(hostURL($scope.ikDomain)+'Sources', function(data) {
			  $scope.srcData = data.Sources;
			  // derive metadata from first row
			  $scope.mdData = new Array();
			  for (md in data.Sources[0]) {
				  if ((md!='ID') && (md!='FullText') && (md!='Sets')) {
					  $scope.mdData[$scope.mdData.length] = md;
				  }
			  }
			  $scope.$apply();
	  	});
	  }
	  
	  this.getSources();
	  
	  this.sortField = undefined;
	  this.reverse = false;
	  
	  this.sort = function (fieldName) {
		  if (this.sortField === fieldName) {
		    this.reverse = !this.reverse;
		  } else {
		    this.sortField = fieldName;
		    this.reverse = false;
		  }
	  };
	  
	  this.isSortUp = function (fieldName) {
		  return this.sortField === fieldName && !this.reverse;
	  };
	         
	  this.isSortDown = function (fieldName) {
		  return this.sortField === fieldName && this.reverse;
	  };
	  
    
  }]);
