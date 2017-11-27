Class Demo.Hotels.Tables.CrcUnique Extends (%Persistent, %iKnow.Tables.AbstractTable) [ Final, Inheritance = right, ProcedureBlock, StorageStrategy = iKnowStorage ]
{

Parameter DOMAINID = 1;

Property CcUniId As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $g(^ISC.IK.CcUni(1,+{MasterId},+{SlaveId}))}, SqlComputed ];

Property CcUnique As CcUnique [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {CcUniId}}, SqlComputed ];

Property CorpusDominance As %Numeric [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Semantics.DominanceAPI).GetDomainValue(1,{CrcUniId},$$$SDCRC)}, SqlComputed ];

Property CorpusFrequency As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.CrcUniDetails(1,{CrcUniId})),1)}, SqlComputed ];

Property CorpusSpread As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.CrcUniDetails(1,{CrcUniId})),2)}, SqlComputed ];

Property CrcUniId As %Integer(MINVAL = 1) [ ReadOnly ];

Property DomainId As %Integer(MINVAL = 1) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = 1}, SqlComputed ];

Property Entities As %List [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $g(^ISC.IK.CrcUniId(1,{CrcUniId}))}, SqlComputed ];

Property Master As EntityUnique [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {MasterId}}, SqlComputed ];

Property MasterId As %Integer(MINVAL = 0) [ ReadOnly ];

Property Relation As EntityUnique [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {RelationId}}, SqlComputed ];

Property RelationId As %Integer(MINVAL = 0) [ ReadOnly ];

Property Slave As EntityUnique [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {SlaveId}}, SqlComputed ];

Property SlaveId As %Integer(MINVAL = 0) [ ReadOnly ];

Property Value As %String(MAXLEN = "") [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $s({MasterId}:##class(EntityUnique).%OpenId({MasterId},0).EntityValue, 1:"") _ " ~ " _ $s({RelationId}:##class(EntityUnique).%OpenId({RelationId},0).EntityValue, 1:"") _ " ~ " _ $s({SlaveId}:##class(EntityUnique).%OpenId({SlaveId},0).EntityValue, 1:"")}, SqlComputed ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %CrcUni On (MasterId, RelationId, SlaveId) [ Type = key, Unique ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %CrcUniExists [ Extent, Type = bitmap ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %CrcUniId On CrcUniId [ IdKey, PrimaryKey, Unique ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %CrcUniIdFreq On (CorpusFrequency As Minus, CrcUniId);

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %CrcUniIdSpread On (CorpusSpread As Minus, CrcUniId);

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntUniMToCrcUniBit On MasterId [ Type = bitmap ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntUniRToCrcUniBit On RelationId [ Type = bitmap ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntUniSToCrcUniBit On SlaveId [ Type = bitmap ];

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

ForeignKey %CcUniqueFK(CcUniId) References Demo.Hotels.Tables.CcUnique() [ NoCheck ];

ForeignKey %MasterFK(MasterId) References EntityUnique() [ NoCheck ];

ForeignKey %RelationFK(RelationId) References EntityUnique() [ NoCheck ];

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
<Value>RelationId</Value>
</Value>
<Value name="3">
<Value>SlaveId</Value>
</Value>
</Data>
<DataLocation>^ISC.IK.CrcUniId(1)</DataLocation>
<DefaultData>CustomData</DefaultData>
<IdLocation>^ISC.IK.CrcUniId(1)</IdLocation>
<Index name="%CrcUni">
<Location>^ISC.IK.CrcUni(1)</Location>
</Index>
<Index name="%CrcUniExists">
<Location>^ISC.IK.CrcUniExistsBit(1)</Location>
</Index>
<Index name="%CrcUniIdFreq">
<Location>^ISC.IK.CrcUniIdFreq(1)</Location>
</Index>
<Index name="%CrcUniIdSpread">
<Location>^ISC.IK.CrcUniIdSpread(1)</Location>
</Index>
<Index name="%EntUniMToCrcUniBit">
<Location>^ISC.IK.EntUniMToCrcUniBit(1)</Location>
</Index>
<Index name="%EntUniRToCrcUniBit">
<Location>^ISC.IK.EntUniRToCrcUniBit(1)</Location>
</Index>
<Index name="%EntUniSToCrcUniBit">
<Location>^ISC.IK.EntUniSToCrcUniBit(1)</Location>
</Index>
<IndexLocation>^ISC.IK.Idx.CRCU(1)</IndexLocation>
<StreamLocation>^Demo.Hotels.Tables.CrcUniqueS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

