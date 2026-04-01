//%attributes = {}
var $documents : cs:C1710.DocumentsSelection
$documents:=ds:C1482.Documents.all()

var $en; $fr : 4D:C1709.Vector
var $AIClient : cs:C1710.AIKit.OpenAI
var $cosineSimilarity : Real
$AIClient:=cs:C1710.AIKit.OpenAI.new()
$AIClient.baseURL:="http://127.0.0.1:8081/v1"

var $batch : cs:C1710.AIKit.OpenAIEmbeddingsResult
var $document : cs:C1710.DocumentsEntity
For each ($document; $documents)
	//Documents should be encoded without instructions
	$batch:=$AIClient.embeddings.create($document.Text)
	If ($batch.success)
		$document.Embeddings:=$batch.embedding.embedding
		$document.save()
	End if 
End for each 