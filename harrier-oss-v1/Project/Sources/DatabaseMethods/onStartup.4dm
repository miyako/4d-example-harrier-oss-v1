var $ONNX : cs:C1710.ONNX.ONNX
var $homeFolder : 4D:C1709.Folder
var $huggingface : cs:C1710.event.huggingface

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
var $port : Integer

/*

ONNX Runtime: 

use int8 quantisation

*/

$homeFolder:=Folder:C1567(fk home folder:K87:24).folder(".ONNX")
$port:=8081
$options:={pooling: "last-token"}

/*
important notice: onnx-genai caps context at 8192 to avoid swapping
the onnx runtime flash attention uses more memory than gguf 
here we use the same model for comparison with llama
but you might want to use the 230m model with shorter vectors.
*/

If (False:C215)
	$folder:=$homeFolder.folder("harrier-oss-v1-270m")
	$path:="harrier-oss-v1-270m-onnx-int8"
	$URL:="keisuke-miyako/harrier-oss-v1-270m-onnx-int8"
Else 
	$folder:=$homeFolder.folder("harrier-oss-v1-0.6b")
	$path:="harrier-oss-v1-0.6b-onnx-int8"
	$URL:="keisuke-miyako/harrier-oss-v1-0.6b-onnx-int8"
End if 

$huggingface:=cs:C1710.event.huggingface.new($folder; $URL; $path; "embedding"; ($URL="@-f16" || ($URL="@-f32")) ? "model.onnx" : "model_quantized.onnx")
$huggingfaces:=cs:C1710.event.huggingfaces.new([$huggingface])

$ONNX:=cs:C1710.ONNX.ONNX.new($port; $huggingfaces; $homeFolder; $options; $event)