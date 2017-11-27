Class Demo.Hotels.Tables.CrcOccurrence Extends (%Persistent, %iKnow.Tables.AbstractTable) [ Final, Inheritance = right, ProcedureBlock, StorageStrategy = iKnowStorage ]
{

Parameter DOMAINID = 1;

Property CcUniId As %Integer(MINVAL = 1) [ Calculated, ReadOnly, SqlComputeCode = {n crc  set crc = $g(^ISC.IK.CrcUniId(1,{CrcUniId})), {*} = $g(^ISC.IK.CcUni(1,+$lg(crc,1),+$lg(crc,3)))}, SqlComputed ];

Property CcUnique As CcUnique [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {CcUniId}}, SqlComputed ];

Property CrcOccId As %Integer(MINVAL = 1) [ ReadOnly ];

Property CrcUniId As %Integer(MINVAL = 1) [ ReadOnly ];

Property CrcUnique As CrcUnique [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {CrcUniId}}, SqlComputed ];

Property DomainId As %Integer(MINVAL = 1) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = 1}, SqlComputed ];

Property MasterOccId As %Integer(MINVAL = 1) [ ReadOnly ];

Property PosInSentence As %Integer(MINVAL = 1) [ ReadOnly ];

Property RelationOccId As %Integer(MINVAL = 1) [ ReadOnly ];

Property Sentence As Sentence [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {SentenceId}}, SqlComputed ];

Property SentenceId As %Integer(MINVAL = 1) [ ReadOnly ];

Property SlaveOccId As %Integer(MINVAL = 1) [ ReadOnly ];

Property Source As Source [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {SourceId}}, SqlComputed ];

Property SourceId As %Integer(MINVAL = 1) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Queries.SentenceAPI).GetSourceId(1,{SentenceId})}, SqlComputed ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %CcUniToOccBit On CcUniId [ Type = bitmap ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %CrcOccId On CrcOccId [ IdKey, PrimaryKey, Unique ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %CrcUniToOccBit On CrcUniId [ Type = bitmap ];

Index CrcOccExtent [ Extent, Type = bitmap ];

ForeignKey %CrcUniFK(CrcUniId) References CrcUnique() [ NoCheck ];

ForeignKey %EntOccMFK(MasterOccId) References Demo.Hotels.Tables.Part() [ NoCheck ];

ForeignKey %EntOccRFK(RelationOccId) References Demo.Hotels.Tables.Part() [ NoCheck ];

ForeignKey %EntOccSFK(SlaveOccId) References Demo.Hotels.Tables.Part() [ NoCheck ];

ForeignKey %SentenceFK(SentenceId) References Sentence() [ NoCheck ];

ForeignKey %SourceFK(SourceId) References Source() [ NoCheck ];

Storage iKnowStorage
{
<Data name="CustomData">
<Subscript>"c"</Subscript>
</Data>
<Data name="iKnowSystemData">
<Value name="1">
<Value>CrcUniId</Value>
</Value>
<Value name="2">
<Value>MasterOccId</Value>
</Value>
<Value name="3">
<Value>RelationOccId</Value>
</Value>
<Value name="4">
<Value>SlaveOccId</Value>
</Value>
<Value name="5">
<Value>SentenceId</Value>
</Value>
<Value name="6">
<Value>PosInSentence</Value>
</Value>
</Data>
<DataLocation>^ISC.IK.CrcOccId(1)</DataLocation>
<DefaultData>CustomData</DefaultData>
<IdLocation>^ISC.IK.CrcOccId(1)</IdLocation>
<Index name="%CcUniToOccBit">
<Location>^ISC.IK.CcUniToOccBit(1)</Location>
</Index>
<Index name="%CrcUniToOccBit">
<Location>^ISC.IK.CrcUniToOccBit(1)</Location>
</Index>
<IndexLocation>^ISC.IK.Idx.CRCO(1)</IndexLocation>
<StreamLocation>^Demo.Hotels6B2A.CrcOccurrenceS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

