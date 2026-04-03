/*

llama-server settings

*/

var $llama : cs:C1710.llama.llama
var $homeFolder : 4D:C1709.Folder
var $huggingface : cs:C1710.event.huggingface

/*

callbacks for downloader (alert on error)

*/

var $event : cs:C1710.event.event
$event:=cs:C1710.event.event.new()
$event.onError:=Formula:C1597(ALERT:C41($2.message))
//$event.onSuccess:=Formula(ALERT($2.models.extract("name").join(",")+" loaded!"))
$event.onData:=Formula:C1597(LOG EVENT:C667(Into 4D debug message:K38:5; This:C1470.file.fullName+":"+String:C10((This:C1470.range.end/This:C1470.range.length)*100; "###.00%")))
$event.onResponse:=Formula:C1597(LOG EVENT:C667(Into 4D debug message:K38:5; This:C1470.file.fullName+":download complete"))
$event.onTerminate:=Formula:C1597(LOG EVENT:C667(Into 4D debug message:K38:5; (["process"; $1.pid; "terminated!"].join(" "))))

var $options : Object
var $huggingfaces : cs:C1710.event.huggingfaces
var $folder : 4D:C1709.Folder
var $path : Text
var $URL : Text
var $pooling : Text

/*

model settings (llama.cpp)

use Q8_0 quantisation

*/

$homeFolder:=Folder:C1567(fk home folder:K87:24).folder(".GGUF")

$folder:=$homeFolder.folder("harrier-oss-v1-0.6b")
$path:="harrier-oss-v1-0.6b-Q8_0.gguf"
$URL:="keisuke-miyako/harrier-oss-v1-0.6b-gguf-q8_0"

var $logFile : 4D:C1709.File
$logFile:=$folder.file("llama.log")
$folder.create()
If (Not:C34($logFile.exists))
	$logFile.setContent(4D:C1709.Blob.new())
End if 
var $max_position_embeddings; $batch_size; $parallel; $threads; $batches : Integer
$max_position_embeddings:=32768
$batch_size:=$max_position_embeddings
$batches:=1
$threads:=8  // M1 Pro P-cores; don't derive this dynamically

var $port : Integer
$port:=8080
$options:={\
embeddings: True:C214; \
pooling: "last"; \
log_file: $logFile; \
ctx_size: $max_position_embeddings*$batches; \
batch_size: $batch_size; \
ubatch_size: 2048; \
parallel: $batches; \
threads: $threads; \
threads_batch: $threads; \
threads_http: 2; \
log_disable: False:C215; \
n_gpu_layers: 0}

$huggingface:=cs:C1710.event.huggingface.new($folder; $URL; $path)
$huggingfaces:=cs:C1710.event.huggingfaces.new([$huggingface])

$llama:=cs:C1710.llama.llama.new($port; $huggingfaces; $homeFolder; $options; $event)