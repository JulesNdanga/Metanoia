class Bookmark {
  int id;
  int v_id;

  Bookmark({
    this.v_id,

  }  );

  factory  Bookmark.fromJson(Map<String, dynamic> json) => new  Bookmark(
    v_id: json["v_id"],
    //Other fields items here
  );
  //
  Map<String, dynamic> toJson() => {
    "v_id":v_id
  };

  Map<String, dynamic> toMap() {
   return {
     "v_id":v_id
   };
  }
}