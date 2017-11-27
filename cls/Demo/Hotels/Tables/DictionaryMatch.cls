Class Demo.Hotels.Tables.DictionaryMatch Extends (%Persistent, %iKnow.Tables.AbstractDictionaryMatch) [ Final, Inheritance = right, ProcedureBlock, StorageStrategy = iKnowStorage ]
{

Property Dictionary As Dictionary [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {DictionaryId}}, SqlComputed ];

Property DictionaryId As %Integer(MINVAL = 1) [ ReadOnly ];

Property DictionaryItem As DictionaryItem [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {DictionaryItemId}}, SqlComputed ];

Property DictionaryItemId As %Integer(MINVAL = 1) [ ReadOnly ];

Property DictionaryTerm As DictionaryTerm [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {DictionaryTermId}}, SqlComputed ];

Property DictionaryTermId As %Integer(MINVAL = 1) [ ReadOnly ];

Property FirstPosInPath As %Integer(MINVAL = 1) [ ReadOnly ];

Property IsInOrder As %Boolean(MINVAL = 1) [ ReadOnly ];

Property LastPosInPath As %Integer(MINVAL = 1) [ ReadOnly ];

Property MatchId As %Integer(MINVAL = 1) [ ReadOnly ];

Property MatchedConceptCount As %Integer(MINVAL = 0) [ ReadOnly ];

Property MatchedRelationCount As %Integer(MINVAL = 0) [ ReadOnly ];

Property NegatedEntityCount As %Integer(MINVAL = 0) [ ReadOnly ];

Property PartialMatchCount As %Integer(MINVAL = 0) [ ReadOnly ];

Property Parts As %List [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(Demo.Hotels.Tables.DictionaryMatch).GetParts({MatchId})}, SqlComputed ];

Property Score As %Numeric(MINVAL = 1) [ ReadOnly ];

Property Sentence As Sentence [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {SentenceId}}, SqlComputed ];

Property SentenceId As %Integer(MINVAL = 1) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Matching.MatchingAPI).GetSentenceIdForMatchTarget(1,{TargetType},{TargetId})}, SqlComputed ];

Property Source As Source [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {SourceId}}, SqlComputed ];

Property SourceId As %Integer(MINVAL = 1) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Matching.MatchingAPI).GetSourceIdForMatchTarget(1,{TargetType},{TargetId})}, SqlComputed ];

Property TargetId As %Integer(MINVAL = 1) [ ReadOnly ];

Property TargetType As %Integer(MINVAL = 1) [ ReadOnly ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %DictToMatch On DictionaryId [ Type = bitmap ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntOccToMatch On Parts(ELEMENTS);

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %ItemToMatch On DictionaryItemId;

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %MatchId On MatchId [ IdKey, PrimaryKey, Unique ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %SourceToMatch On SourceId;

Index DictMatchExtent [ Extent, Type = bitmap ];

ClassMethod PartsBuildValueArray(pEntities As %List, Output pArray As %String) As %Status
{
	set tSC = $$$OK
	try {
		kill pArray
		set ptr = 0
		while $listnext(pEntities,ptr,tElement) {
			set pArray(tElement) = ""
		}
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

Storage iKnowStorage
{
<Data name="CustomData">
<Subscript>"c"</Subscript>
</Data>
<Data name="iKnowSystemData">
<Value name="1">
<Value>DictionaryId</Value>
</Value>
<Value name="2">
<Value>DictionaryItemId</Value>
</Value>
<Value name="3">
<Value>DictionaryTermId</Value>
</Value>
<Value name="4">
<Value>TargetType</Value>
</Value>
<Value name="5">
<Value>TargetId</Value>
</Value>
<Value name="6">
<Value>Score</Value>
</Value>
<Value name="7">
<Value>MatchedConceptCount</Value>
</Value>
<Value name="8">
<Value>MatchedRelationCount</Value>
</Value>
<Value name="9">
<Value>PartialMatchCount</Value>
</Value>
<Value name="10">
<Value>FirstPosInPath</Value>
</Value>
<Value name="11">
<Value>LastPosInPath</Value>
</Value>
<Value name="12">
<Value>IsInOrder</Value>
</Value>
<Value name="13">
<Value>NegatedEntityCount</Value>
</Value>
</Data>
<DataLocation>^ISC.IK.Mat.MatchId(1)</DataLocation>
<DefaultData>CustomData</DefaultData>
<IdLocation>^ISC.IK.Mat.MatchId(1)</IdLocation>
<Index name="%DictToMatch">
<Location>^ISC.IK.Mat.DictToMatchBit(1)</Location>
</Index>
<Index name="%EntOccToMatch">
<Location>^ISC.IK.Mat.EntOccToMatch(1)</Location>
</Index>
<Index name="%ItemToMatch">
<Location>^ISC.IK.Mat.DictItemToMatch(1)</Location>
</Index>
<Index name="%SourceToMatch">
<Location>^ISC.IK.Mat.SrcToMatch(1)</Location>
</Index>
<IndexLocation>^ISC.IK.Idx.MM(1)</IndexLocation>
<StreamLocation>^Demo.Hotel6B2A.DictionaryM44DAS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

