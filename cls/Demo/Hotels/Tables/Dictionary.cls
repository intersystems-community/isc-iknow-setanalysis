Class Demo.Hotels.Tables.Dictionary Extends (%Persistent, %iKnow.Tables.AbstractTable) [ Final, Inheritance = right, ProcedureBlock, StorageStrategy = iKnowStorage ]
{

Property DefaultLanguage As %String(MAXLEN = 150) [ ReadOnly ];

Property Description As %String(MAXLEN = "") [ ReadOnly ];

Property DictionaryId As %Integer(MINVAL = 1) [ ReadOnly ];

Property Name As %String(MAXLEN = 1000) [ ReadOnly ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %DictName On Name [ Type = key, Unique ];

/// This index is maintained automatically by iKnow. DO NOT MODIFY
Index %DictionaryId On DictionaryId [ IdKey, PrimaryKey, Unique ];

Index DictExtent [ Extent, Type = bitmap ];

Storage iKnowStorage
{
<Data name="CustomData">
<Subscript>"c"</Subscript>
</Data>
<Data name="iKnowSystemData">
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>DefaultLanguage</Value>
</Value>
</Data>
<DataLocation>^ISC.IK.Mat.DictId(1)</DataLocation>
<DefaultData>CustomData</DefaultData>
<IdLocation>^ISC.IK.Mat.DictId(1)</IdLocation>
<Index name="%DictName">
<Location>^ISC.IK.Mat.Dict(1)</Location>
</Index>
<IndexLocation>^ISC.IK.Idx.MD(1)</IndexLocation>
<StreamLocation>^Demo.Hotels.Tables.DictionaryS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

