class Pokemon
{
  int index;
  String name;
  String imageUrl;
  String shoutUrl;

  Pokemon(this.index,this.name,this.imageUrl,this.shoutUrl);

  factory Pokemon.empty()
  {
    return Pokemon(0, "", "", "");  
  }
}