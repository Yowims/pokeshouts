class FileInfo
{
  final String url;
  final String descriptionurl;
  final String descriptionshorturl;

  FileInfo(this.url, this.descriptionshorturl, this.descriptionurl);

  factory FileInfo.fromJson(Map<String,dynamic>? json)
  {
    if(json == null) 
    {
      return FileInfo("", "", "");
    } 
    else
    {
      return FileInfo(json["url"], json["descriptionshorturl"], json["descriptionurl"]);
    }
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'descriptionurl': descriptionurl,
    'descriptionshorturl': descriptionshorturl
  };
}