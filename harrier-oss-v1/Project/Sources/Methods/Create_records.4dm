//%attributes = {}
TRUNCATE TABLE:C1051([Documents:1])
SET DATABASE PARAMETER:C642([Documents:1]; Table sequence number:K37:31; 0)

var $files : Collection
$files:=Folder:C1567(fk resources folder:K87:11).files(Ignore invisible:K24:16 | Recursive parsing:K24:13).query("extension == :1"; ".md")
var $prefix : Integer
$prefix:=Length:C16(Folder:C1567("/RESOURCES/doc/").path)+2  //to make relative path

var $file : 4D:C1709.File
For each ($file; $files)
	var $document : cs:C1710.DocumentsEntity
	$document:=ds:C1482.Documents.new()
	$document.Text:=$file.getText()
	$document.Path:=Substring:C12($file.path; $prefix)
	$document.save()
End for each 