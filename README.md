## [microsoft/harrier-oss-v1-0.6b](https://huggingface.co/microsoft/harrier-oss-v1-0.6b)

**Harrier OSS** is a decoder-only text embedding model released by **Microsoft* in 2026. 

|`max_position_embeddings`|`hidden_size`|`num_hidden_layers`|`pooling`
|-:|-:|-:|-:|
|`32768`|`1024`|`28`|`last`

```4d
var $AIClient : cs.AIKit.OpenAI
$AIClient:=cs.AIKit.OpenAI.new()

$AIClient.baseURL:="http://127.0.0.1:8080/v1"  // llama-server

$query:="Instruct: Retrieve text that answers the question\nQuery: "+"What is the TCP port number used by 4D Server?"

var $batch : cs.AIKit.OpenAIEmbeddingsResult
$batch:=$AIClient.embeddings.create($query)

If ($batch.success)
	$vector:=$batch.embedding.embedding
	var $comparison:={vector: $vector; metric: mk cosine; threshold: 0.6}
	var $results:=ds.Documents.query("Embeddings > :1"; $comparison)
	If ($results.length#0)
		ALERT($results.first().Text)
	End if 
End if 
```

<img width="480" height="542" alt="" src="https://github.com/user-attachments/assets/8172b78c-249e-4039-b904-755d251776b0" />

## ONNX Runtime

ONNX uses less CPU, more memory. Bug?

<img width="833" height="384" alt="" src="https://github.com/user-attachments/assets/5e56dd0a-018a-4833-9b99-8b177988fc20" />

