Class Demo.Hotels.Tables.Part Extends (%Persistent, %iKnow.Tables.AbstractPart) [ Final, Inheritance = right, ProcedureBlock, StorageStrategy = iKnowStorage ]
{

Parameter DOMAINID = 1;

Property Annotations As %ArrayOfObjects [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(Demo.Hotels.Tables.Part).GetAnnotations({PartId})}, SqlComputed ];

Property Attributes As %ArrayOfObjects [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(Demo.Hotels.Tables.Part).GetAttributes({PartId})}, SqlComputed ];

Property CrcOccurrenceIdM As %Integer(MINVAL = 0) [ ReadOnly ];

Property CrcOccurrenceIdR As %Integer(MINVAL = 0) [ ReadOnly ];

Property CrcOccurrenceIdS As %Integer(MINVAL = 0) [ ReadOnly ];

Property DictionaryMatches As %ArrayOfObjects [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(Demo.Hotels.Tables.Part).GetDictionaryMatches({PartId})}, SqlComputed ];

Property DomainId As %Integer(MINVAL = 1) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = 1}, SqlComputed ];

Property EntTypeId As %Integer(VALUELIST = "0,1,2,3") [ ReadOnly ];

Property EntUniId As %Integer(MINVAL = 1) [ ReadOnly ];

Property Entity As EntityUnique [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {EntUniId}}, SqlComputed ];

Property EntityValue As %String(MAXLEN = "") [ Calculated, ReadOnly, SqlComputeCode = {new tObj  if '{EntUniId} { set {*} = "" } else { set tObj = ##class(EntityUnique).%OpenId({EntUniId},0), {*} = $s($isobject(tObj):tObj.EntityValue, 1:"") }}, SqlComputed ];

Property Literal As %String(MAXLEN = "") [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Queries.EntityAPI).GetLiteral(1,{PartId})}, SqlComputed ];

Property PartId As %Integer(MINVAL = 1) [ ReadOnly ];

Property Path As Path [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {PathId}}, SqlComputed ];

Property PathId As %Integer(MINVAL = 1) [ ReadOnly ];

Property PosInPath As %Integer(MINVAL = 0) [ ReadOnly ];

Property PosInSentence As %Integer(MINVAL = 1) [ ReadOnly ];

Property Sentence As Sentence [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {SentenceId}}, SqlComputed ];

Property SentenceId As %Integer(MINVAL = 1) [ ReadOnly ];

Property Source As Source [ Calculated, ReadOnly, SqlComputeCode = {set {*} = {SourceId}}, SqlComputed ];

Property SourceId As %Integer(MINVAL = 1) [ Calculated, ReadOnly, SqlComputeCode = {set {*} = ##class(%iKnow.Queries.SentenceAPI).GetSourceId(1,{SentenceId})}, SqlComputed ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntTypeToOccBit On EntTypeId [ Type = bitslice ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %EntUniToOccBit On EntUniId [ Type = bitmap ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %PartId On PartId [ IdKey, PrimaryKey, Unique ];

Index PartExtent [ Extent, Type = bitmap ];

ForeignKey %CrcOccMFK(CrcOccurrenceIdM) References Demo.Hotels.Tables.CrcOccurrence() [ NoCheck ];

ForeignKey %CrcOccRFK(CrcOccurrenceIdR) References Demo.Hotels.Tables.CrcOccurrence() [ NoCheck ];

ForeignKey %CrcOccSFK(CrcOccurrenceIdS) References Demo.Hotels.Tables.CrcOccurrence() [ NoCheck ];

ForeignKey %EntUniFK(EntUniId) References Demo.Hotels.Tables.EntityUnique() [ NoCheck ];

ForeignKey %PathFK(PathId) References Demo.Hotels.Tables.Path() [ NoCheck ];

ForeignKey %SentenceFK(SentenceId) References Demo.Hotels.Tables.Sentence() [ NoCheck ];

ForeignKey %SourceFK(SourceId) References Demo.Hotels.Tables.Source() [ NoCheck ];

Storage iKnowStorage
{
<Data name="CustomData">
<Subscript>"c"</Subscript>
</Data>
<Data name="iKnowSystemData">
<Value name="1">
<Value>EntUniId</Value>
</Value>
<Value name="2">
<Value>EntTypeId</Value>
</Value>
<Value name="3">
<Value>SentenceId</Value>
</Value>
<Value name="4">
<Value>PosInSentence</Value>
</Value>
<Value name="5">
<Value>CrcOccurrenceIdM</Value>
</Value>
<Value name="6">
<Value>CrcOccurrenceIdR</Value>
</Value>
<Value name="7">
<Value>CrcOccurrenceIdS</Value>
</Value>
<Value name="8">
<Value>PathId</Value>
</Value>
<Value name="9">
<Value>PosInPath</Value>
</Value>
</Data>
<DataLocation>^ISC.IK.EntOccId(1)</DataLocation>
<DefaultData>CustomData</DefaultData>
<IdLocation>^ISC.IK.EntOccId(1)</IdLocation>
<Index name="%EntTypeToOccBit">
<Location>^ISC.IK.EntTypeToOccBit(1)</Location>
</Index>
<Index name="%EntUniToOccBit">
<Location>^ISC.IK.EntUniToOccBit(1)</Location>
</Index>
<IndexLocation>^ISC.IK.Idx.EO(1)</IndexLocation>
<StreamLocation>^Demo.Hotels.Tables.PartS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

