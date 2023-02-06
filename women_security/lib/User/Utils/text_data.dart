import 'package:google_maps_flutter/google_maps_flutter.dart';

class TextData{
  static List<String> states = [
    "Andaman and Nicobar Islands",
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chandigarh",
    "Chhattisgarh",
    "Dadra and Nagar Haveli",
    "Delhi",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Karnatka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Puducherry",
    "Punjab",
    "Rajasthan",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
  ];
  static List<LatLng> policeStationLocations = [
    const LatLng(22.726932, 75.815687),
    const LatLng(22.695916, 75.841964),
    const LatLng(22.700562, 75.884454),
    const LatLng(22.691989, 75.867951),
    const LatLng(22.705661, 75.825876),
    const LatLng(22.737284, 75.884993),
    const LatLng(22.751636, 75.895184),
    const LatLng(22.721773, 75.874089),
    const LatLng(22.70611, 75.86028),
    const LatLng(22.7252, 75.8878),
    const LatLng(22.7178, 75.8644),
  ];

  static List<String> policeStationNames = [
    "areodrum",
    "Annapurna",
    "Azad Nagar",
    "BhawarKuan",
    "chandan nagar",
    "MIG",
    "Vijay Nagar",
    "Tukogand",
    "Juni Indore",
    "Palasia",
    "Central Kothwai",
  ];
  static Set<List<String>> addedPreferences = {};
}