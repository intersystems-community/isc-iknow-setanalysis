Class Demo.Hotels.Tables.PathAttribute Extends (%Persistent, %iKnow.Tables.AbstractTable) [ Final, Inheritance = right, ProcedureBlock, StorageStrategy = iKnowStorage ]
{

Parameter DOMAINID = 1;

Property AttributeTypeId As %Integer(MINVAL = 1) [ ReadOnly ];

Property DomainId As %Integer(MINVAL = 1) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = 1}, SqlComputed ];

Property Parts As %List [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $li($g(^ISC.IK.PathToEntOcc(1,{PathId})),{StartPosInPath},{StartPosInPath}+{SpanInPath}-1)}, SqlComputed ];

Property Path As Path [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {PathId}}, SqlComputed ];

Property PathId As %Integer(MINVAL = 1) [ ReadOnly ];

Property SpanInPath As %Integer(MINVAL = 1) [ ReadOnly ];

Property StartPosInPath As %Integer(MINVAL = 1) [ ReadOnly ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %PathAttribute On (PathId, AttributeTypeId, StartPosInPath) [ IdKey, PrimaryKey, Unique ];

ForeignKey %PathFK(PathId) References Path() [ NoCheck ];

Storage iKnowStorage
{
<Data name="CustomData">
<Subscript>"c"</Subscript>
</Data>
<Data name="iKnowSystemData">
<Value name="1">
<Value>SpanInPath</Value>
</Value>
</Data>
<DataLocation>^ISC.IK.Att.Path(1)</DataLocation>
<DefaultData>CustomData</DefaultData>
<IdLocation>^ISC.IK.Att.Path(1)</IdLocation>
<IndexLocation>^ISC.IK.Idx.ATP(1)</IndexLocation>
<StreamLocation>^Demo.Hotels6B2A.PathAttributeS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

