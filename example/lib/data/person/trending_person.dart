

class TrandingPersonRespo {
  int page;
  List<Results> results;
  int totalPages;
  int totalResults;

  TrandingPersonRespo(
      {this.page, this.results, this.totalPages, this.totalResults});

  TrandingPersonRespo.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    data['total_pages'] = this.totalPages;
    data['total_results'] = this.totalResults;
    return data;
  }
}

class Results {
  bool adult;
  int gender;
  String name;
  int id;
  // List<NowPlayResult> knownFor;
  String knownForDepartment;
  String profilePath;
  double popularity;
  String mediaType;

  Results(
      {this.adult,
        this.gender,
        this.name,
        this.id,
        // this.knownFor,
        this.knownForDepartment,
        this.profilePath,
        this.popularity,
        this.mediaType});

  Results.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    gender = json['gender'];
    name = json['name'];
    id = json['id'];
    // if (json['known_for'] != null) {
    //     knownFor = new List<NowPlayResult>();
    //     json['known_for'].forEach((v) {
    //         knownFor.add(new NowPlayResult.fromJson(v));
    //     });
    // }
    knownForDepartment = json['known_for_department'];
    profilePath = json['profile_path'];
    popularity = json['popularity'];
    mediaType = json['media_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adult'] = this.adult;
    data['gender'] = this.gender;
    data['name'] = this.name;
    data['id'] = this.id;
    // if (this.knownFor != null) {
    //     data['known_for'] = this.knownFor.map((v) => v.toJson()).toList();
    // }
    data['known_for_department'] = this.knownForDepartment;
    data['profile_path'] = this.profilePath;
    data['popularity'] = this.popularity;
    data['media_type'] = this.mediaType;
    return data;
  }
}