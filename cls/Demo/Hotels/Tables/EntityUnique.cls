Class Demo.Hotels.Tables.EntityUnique Extends (%Persistent, %iKnow.Tables.AbstractTable) [ Final, Inheritance = right, ProcedureBlock, StorageStrategy = iKnowStorage ]
{

Parameter DOMAINID = 1;

Property CorpusDominanceAsConcept As %Numeric [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Semantics.DominanceAPI).GetDomainValue(1,{EntUniId},$$$SDCONCEPT)}, SqlComputed ];

Property CorpusDominanceAsRelation As %Numeric [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Semantics.DominanceAPI).GetDomainValue(1,{EntUniId},$$$SDRELATION)}, SqlComputed ];

Property CorpusFrequency As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {CorpusFrequencyAsConcept} + {CorpusFrequencyAsRelation}}, SqlComputed ];

Property CorpusFrequencyAsConcept As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.EntUniDetails(1,{EntUniId})),1)}, SqlComputed ];

Property CorpusFrequencyAsRelation As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.EntUniDetails(1,{EntUniId})),2)}, SqlComputed ];

Property CorpusSpread As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.EntUniDetails(1,{EntUniId})),3)}, SqlComputed ];

Property CorpusSpreadAsConcept As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.EntUniDetails(1,{EntUniId})),4)}, SqlComputed ];

Property CorpusSpreadAsRelation As %Integer(MINVAL = 0) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = $lg($g(^ISC.IK.EntUniDetails(1,{EntUniId})),5)}, SqlComputed ];

Property DomainId As %Integer(MINVAL = 1) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = 1}, SqlComputed ];

Property EntUniId As %Integer(MINVAL = 1) [ ReadOnly ];

Property EntityValue As %String(COLLATION = "SQLSTRING", MAXLEN = "") [ ReadOnly ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntUni On EntityValue [ Type = collatedkey, Unique ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntUniExists [ Extent, Type = bitmap ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntUniFreqCon On CorpusFrequencyAsConcept As Minus;

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntUniFreqRel On CorpusFrequencyAsRelation As Minus;

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntUniId On EntUniId [ IdKey, PrimaryKey, Unique ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntUniSpreadCon On CorpusSpreadAsConcept As Minus;

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntUniSpreadRel On CorpusSpreadAsRelation As Minus;

Storage iKnowStorage
{
<Data name="CustomData">
<Subscript>"c"</Subscript>
</Data>
<Data name="iKnowSystemData">
<Attribute>EntityValue</Attribute>
<Structure>node</Structure>
</Data>
<DataLocation>^ISC.IK.EntUniId(1)</DataLocation>
<DefaultData>CustomData</DefaultData>
<IdLocation>^ISC.IK.EntUniId(1)</IdLocation>
<Index name="%EntUni">
<Location>^ISC.IK.EntUni(1)</Location>
</Index>
<Index name="%EntUniExists">
<Location>^ISC.IK.EntUniExistsBit(1)</Location>
</Index>
<Index name="%EntUniFreqCon">
<Location>^ISC.IK.EntUniIdFreq(1,0)</Location>
</Index>
<Index name="%EntUniFreqRel">
<Location>^ISC.IK.EntUniIdFreq(1,1)</Location>
</Index>
<Index name="%EntUniSpreadCon">
<Location>^ISC.IK.EntUniIdSpread(1,0)</Location>
</Index>
<Index name="%EntUniSpreadRel">
<Location>^ISC.IK.EntUniIdSpread(1,1)</Location>
</Index>
<IndexLocation>^ISC.IK.Idx.EU(1)</IndexLocation>
<StreamLocation>^Demo.Hotels.T6B2A.EntityUniqueS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

