Class Demo.Hotels.Tables.Path Extends (%Persistent, %iKnow.Tables.AbstractTable) [ Final, Inheritance = right, ProcedureBlock, StorageStrategy = iKnowStorage ]
{

Parameter DOMAINID = 1;

Property DomainId As %Integer(MINVAL = 1) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = 1}, SqlComputed ];

Property Entities As %List [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Queries.PathAPI).GetEntIds(1,{PathId})}, SqlComputed ];

Property EntityOccurrences As %List [ ReadOnly ];

Property PathId As %Integer(MINVAL = 1) [ ReadOnly ];

Property Sentence As Sentence [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {SentenceId}}, SqlComputed ];

Property SentenceId As %Integer(MINVAL = 1) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Queries.PathAPI).GetSentenceId(1,{PathId})}, SqlComputed ];

Property Source As Source [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {SourceId}}, SqlComputed ];

Property SourceId As %Integer(MINVAL = 1) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Queries.PathAPI).GetSourceId(1,{PathId})}, SqlComputed ];

Property Value As %String [ Calculated, ReadOnly, SqlComputeCode = {new tEntity,tEntList,tValue,tPointer  set tEntList = {Entities}, tPointer=0, tValue=""  while $listnext(tEntList,tPointer,tEntity) { set tValue = tValue _ $s(tValue="":"", 1:" ~ ") _ ##class(%iKnow.Queries.EntityAPI).GetValueInternal(1,tEntity) }  set {*} = tValue}, SqlComputed ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntUniToPath On Entities(KEYS) [ Type = bitmap ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %PathId On PathId [ IdKey, PrimaryKey, Unique ];

Index PathExtent [ Extent, Type = bitmap ];

ClassMethod EntitiesBuildValueArray(pEntities As %List, Output pArray As %String) As %Status
{
	set tSC = $$$OK
	try {
		kill pArray
		set ptr = 0
		while $listnext(pEntities,ptr,tElement) {
			continue:'tElement
			set pArray(tElement) = $g(^ISC.IK.EntUniId(1,tElement))
		}
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

ForeignKey %SentenceFK(SentenceId) References Demo.Hotels.Tables.Source() [ NoCheck ];

ForeignKey %SourceFK(SourceId) References Demo.Hotels.Tables.Source() [ NoCheck ];

Storage iKnowStorage
{
<Data name="CustomData">
<Subscript>"c"</Subscript>
</Data>
<Data name="iKnowSystemData">
<Attribute>EntityOccurrences</Attribute>
<Structure>node</Structure>
</Data>
<DataLocation>^ISC.IK.PathToEntOcc(1)</DataLocation>
<DefaultData>CustomData</DefaultData>
<IdLocation>^ISC.IK.PathToEntOcc(1)</IdLocation>
<Index name="%EntUniToPath">
<Location>^ISC.IK.EntUniToPathBit(1)</Location>
</Index>
<IndexLocation>^ISC.IK.Idx.Path(1)</IndexLocation>
<StreamLocation>^Demo.Hotels.Tables.PathS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

