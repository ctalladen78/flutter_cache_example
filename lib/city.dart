
class City {
  String objectId;
  String country;
  String imageLink;
  String cityName;
  String cityPlaceId;

  City(
      {this.objectId,
      this.country,
      this.imageLink,
      this.cityName,
      this.cityPlaceId});

  City.fromJson(Map<String, dynamic> json) {
    objectId = json['object_id'];
    cityPlaceId = json['place_id'];
    cityName = json['city_name'];
    country = json['country'];
    imageLink = json['image_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object_id'] = this.objectId;
    data['country'] = this.country;
    data['image_link'] = this.imageLink;
    data['city_name'] = this.cityName;
    data['place_id'] = this.cityPlaceId;
    return data;
  }
}
