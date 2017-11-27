Class Demo.Hotels.Tables.CcUnique Extends (%Persistent, %iKnow.Tables.AbstractTable) [ Final, Inheritance = right, ProcedureBlock, StorageStrategy = iKnowStorage ]
{

Parameter DOMAINID = 1;

Property CcUniId As %Integer(MINVAL = 1) [ ReadOnly ];

Property CorpusFrequency As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.CcUniDet(1,{CcUniId})),1)}, SqlComputed ];

Property CorpusSpread As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.CcUniDet(1,{CcUniId})),2)}, SqlComputed ];

Property DomainId As %Integer(MINVAL = 1) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = 1}, SqlComputed ];

Property Master As EntityUnique [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {MasterId}}, SqlComputed ];

Property MasterId As %Integer(MINVAL = 0) [ ReadOnly ];

Property Slave As EntityUnique [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {SlaveId}}, SqlComputed ];

Property SlaveId As %Integer(MINVAL = 0) [ ReadOnly ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %CcUni On (MasterId, SlaveId) [ Type = key, Unique ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %CcUniExists [ Extent, Type = bitmap ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %CcUniId On CcUniId [ IdKey, PrimaryKey, Unique ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %CcUniIdFreq On (CorpusFrequency As Minus, CcUniId);

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %CcUniIdSpread On (CorpusSpread As Minus, CcUniId);

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntUniMToCcUniBit On MasterId [ Type = bitmap ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntUniSToCcUniBit On SlaveId [ Type = bitmap ];

ForeignKey %MasterFK(MasterId) References EntityUnique() [ NoCheck ];

ForeignKey %SlaveFK(SlaveId) References EntityUnique() [ NoCheck ];

Storage iKnowStorage
{
<Data name="CustomData">
<Subscript>"c"</Subscript>
</Data>
<Data name="iKnowSystemData">
<Value name="1">
<Value>MasterId</Value>
</Value>
<Value name="2">
<Value>SlaveId</Value>
</Value>
</Data>
<DataLocation>^ISC.IK.CcUniId(1)</DataLocation>
<DefaultData>CustomData</DefaultData>
<IdLocation>^ISC.IK.CcUniId(1)</IdLocation>
<Index name="%CcUni">
<Location>^ISC.IK.CcUni(1)</Location>
</Index>
<Index name="%CcUniExists">
<Location>^ISC.IK.CcUniExistsBit(1)</Location>
</Index>
<Index name="%CcUniIdFreq">
<Location>^ISC.IK.CcUniIdFreq(1)</Location>
</Index>
<Index name="%CcUniIdSpread">
<Location>^ISC.IK.CcUniIdSpread(1)</Location>
</Index>
<Index name="%EntUniMToCcUniBit">
<Location>^ISC.IK.EntUniMToCcUniBit(1)</Location>
</Index>
<Index name="%EntUniSToCcUniBit">
<Location>^ISC.IK.EntUniSToCcUniBit(1)</Location>
</Index>
<IndexLocation>^ISC.IK.Idx.CCU(1)</IndexLocation>
<StreamLocation>^Demo.Hotels.Tables.CcUniqueS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

