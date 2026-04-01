//%attributes = {}
var $AIClient : cs:C1710.AIKit.OpenAI
$AIClient:=cs:C1710.AIKit.OpenAI.new()

$AIClient.baseURL:="http://127.0.0.1:8081/v1"  // onnx-genai

$query:="Instruct: Retrieve text that answers the question\nQuery: "+"What is the TCP port number used by 4D Server?"

var $batch : cs:C1710.AIKit.OpenAIEmbeddingsResult
$batch:=$AIClient.embeddings.create($query)

If ($batch.success)
	$vector:=$batch.embedding.embedding
	var $comparison:={vector: $vector; metric: mk cosine:K95:1; threshold: 0.6}
	var $results:=ds:C1482.Documents.query("Embeddings > :1"; $comparison)
	If ($results.length#0)
		ALERT:C41($results.first().Text)
	End if 
End if 