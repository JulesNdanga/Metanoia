class detail {
  int Id;
  int Category_Id;
  //Chapter
  String Chapter;
  String fr_Chapter;
 
  //Description
  String Description;
  String fr_Description;

  //Short_Description
  String Short_Description;
  String fr_Short_Description;

  //Chapter_Count
  int Chapter_Count;

  //For BookMark
  //Author_name
  String en_Author_name;
  String fr_Author_name;

  //title
  String Title;
  String fr_Title;

  int Chapter_Total;

  detail({
    this.Id,
    this.Category_Id,
    //Chapter
    this.Chapter,
    this.fr_Chapter,
  
    //Description
    this.Description,
    this.fr_Description,

    //Short_Description
    this.Short_Description,
    this.fr_Short_Description,

    this.Chapter_Count,
    //Author_name

    this.en_Author_name,
    this.fr_Author_name,
    //title
    this.Title,
    this.fr_Title,

    //Chapter_Total
    this.Chapter_Total,
  });
  factory detail.fromJson(Map<String, dynamic> json) => new detail(
        Id: json["Id"],
        Category_Id: json["Category_Id"],
        //Chapter
        Chapter: json["Chapter"],
        fr_Chapter: json["fr_Chapter"],
        
        //Description
        Description: json["Description"],
        fr_Description: json["fr_Description"],
       
        Short_Description: json["Short_Description"],
        fr_Short_Description: json["fr_Short_Description"],
     
        //Chapter_Count
        Chapter_Count: json["Chapter_Count"],

        //Author_name
        en_Author_name: json["en_Author_name"],
        fr_Author_name: json["fr_Author_name"],

        //title
        Title: json["Title"],
        fr_Title: json["fr_Title"],
        
        //Chapter_Total
        Chapter_Total: json["Total_Chapter"],
        //Other fields items here
      );
}
