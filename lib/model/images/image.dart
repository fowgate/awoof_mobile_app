import 'dart:convert';
import 'package:awoof_app/model/images/metadata.dart';

/// A class to hold my [Images] model
class Images {

  /// Setting constructor for [Images] class
  Images({
    required this.fieldName,
    required this.originalName,
    required this.encoding,
    required this.mimeType,
    required this.size,
    required this.bucket,
    required this.key,
    required this.acl,
    required this.contentType,
    required this.contentDisposition,
    required this.storageClass,
    required this.serverSideEncryption,
    required this.metadata,
    required this.location,
    required this.eTag,
  });

  /// A string variable to hold my field name
  String fieldName;

  /// A string variable to hold my original name
  String originalName;

  /// A string variable to hold my encoding
  String encoding;

  /// A string variable to hold my image mime type
  String mimeType;

  /// An Integer variable to hold my image size
  String size;

  /// A string variable to hold my image bucket
  String bucket;

  /// A string variable to hold my image key
  String key;

  /// A string variable to hold my image acl
  String acl;

  /// A string variable to hold my content type
  String contentType;

  /// A string variable to hold my content description
  String contentDisposition;

  /// A string variable to hold my storage class
  String storageClass;

  /// A string variable to hold my server side encryption
  String serverSideEncryption;

  /// A [Metadata] object to hold my image metadata
  Metadata metadata;

  /// A string variable to hold my image location
  String location;

  /// A string variable to hold my etag
  String eTag;

  /// A factory method to map my raw JSON values to the model details accordingly
  factory Images.fromRawJson(String str) => Images.fromJson(json.decode(str));

  /// A method to send my raw JSON values of the class
  String toRawJson() => json.encode(toJson());

  /// Creating a method to map my JSON values to the model details accordingly
  factory Images.fromJson(Map<String, dynamic> json) => Images(
    fieldName: json["fieldname"].toString(),
    originalName: json["originalname"].toString(),
    encoding: json["encoding"].toString(),
    mimeType: json["mimetype"].toString(),
    size: json["size"].toString(),
    bucket: json["bucket"].toString(),
    key: json["key"].toString(),
    acl: json["acl"].toString(),
    contentType: json["contentType"].toString(),
    contentDisposition: json["contentDisposition"].toString(),
    storageClass: json["storageClass"].toString(),
    serverSideEncryption: json["serverSideEncryption"].toString(),
    metadata: Metadata.fromJson(json["metadata"]),
    location: json["location"].toString(),
    eTag: json["etag"].toString(),
  );

  /// Creating a method to map my values to JSON values with the model details accordingly
  Map<String, dynamic> toJson() => {
    "fieldname": fieldName,
    "originalname": originalName,
    "encoding": encoding,
    "mimetype": mimeType,
    "size": size,
    "bucket": bucket,
    "key": key,
    "acl": acl,
    "contentType": contentType,
    "contentDisposition": contentDisposition,
    "storageClass": storageClass,
    "serverSideEncryption": serverSideEncryption,
    "metadata": metadata.toJson(),
    "location": location,
    "etag": eTag,
  };
}