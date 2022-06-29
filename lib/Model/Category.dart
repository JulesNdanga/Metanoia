class Category {
  int Id;
  //title
  String Title;
  String fr_Title;
 
  //Author
  String Author;
  String fr_Author;


  int Chapter;

  Category({
    this.Id,
    //title
    this.Title,
    this.fr_Title,

    // Author
    this.Author,
    this.fr_Author,
    this.Chapter,
  });
  factory Category.fromJson(Map<String, dynamic> json) => new Category(
        Id: json["Id"],
        //title
        Title: json["Title"],
        fr_Title: json["fr_Title"],
        Author: json["Author_name"],
        Chapter: json["Total_Chapter"],

        fr_Author: json["fr_Author_name"],

        //Other fields items here
      );
}
