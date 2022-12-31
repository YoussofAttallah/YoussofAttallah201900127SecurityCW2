import 'package:cw_1/constant.dart';
import 'package:encrypt/encrypt.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert' show utf8;
import 'functions.dart';

class MongoDb {
  connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
  }

  addRecord(String userName, String hashedPassword, DateTime expireyDate,
      String companyTeam) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME);
    await collection.insertOne({
      "username": userName,
      "password": hashedPassword,
      "expire": expireyDate,
      "team": companyTeam,
      "password_attempts": 4
    });
  }

  addMemo(Encrypted title, Encrypted description, String companyTeam) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_MEMO);
    await collection.insertOne({
      "title": title,
      "description": description,
      "view": companyTeam,
    });
  }

  verifyUser(String userName, String hashedPassword) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME);
    var users = await collection.find({"username": userName}).toList();
    var finalList = [];
    for (var element in users) {
      finalList.add(element);
    }
    var splitRecord = (finalList[0]
        .toString()
        .substring(1, finalList[0].toString().length - 2)
        .split(','));
    var passwordValue = splitRecord[2].split(':');
    return (passwordValue[1].substring(1) == hashedPassword);
  }

  checkExistenceCompany(String companyID) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var mainCollection = db.collection(COLLECTION_MAIN);
    var users = await mainCollection.find({"company_id": companyID}).toList();
    List finalList = [];
    for (var element in users) {
      finalList.add(element);
    }
    return (finalList.isNotEmpty);
  }

  checkExistenceUsername(String username) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var mainCollection = db.collection(COLLECTION_MAIN);
    var users = await mainCollection.find({"username": username}).toList();
    List finalList = [];
    for (var element in users) {
      finalList.add(element);
    }
    return (finalList.isEmpty);
  }

  checkExistenceSignUp(String username) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var mainCollection = db.collection(COLLECTION_NAME);
    var users = await mainCollection.find({"username": username}).toList();
    List finalList = [];
    for (var element in users) {
      finalList.add(element);
    }
    return (finalList.isEmpty);
  }

  chechPasswordValid(String username) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var mainCollection = db.collection(COLLECTION_NAME);
    var users = await mainCollection.find({"username": username}).toList();
    List finalList = [];
    for (var element in users) {
      finalList.add(element);
    }
    var splitRecord = (finalList[0]
        .toString()
        .substring(1, finalList[0].toString().length - 2)
        .split(','));
    var dateValue = splitRecord[3].split(':');
    var dateValueSplit = dateValue[1].substring(1);
    DateTime tempDate = DateTime.parse(dateValueSplit);
    return (tempDate.isAfter(DateTime.now()));
  }

  editAttempts(String username) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var mainCollection = db.collection(COLLECTION_NAME);
    var user = await mainCollection.findOne({"username": username});
    user!["password_attempts"] = user["password_attempts"] - 1;
    await mainCollection.save(user);
  }

  checkLock(String username) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var mainCollection = db.collection(COLLECTION_NAME);
    var user = await mainCollection.findOne({"username": username});
    return user!["password_attempts"] != 0;
  }

  getMemo(String username) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var mainCollection = db.collection(COLLECTION_NAME);
    var memoCollection = db.collection(COLLECTION_MEMO);
    var user = await mainCollection.findOne({"username": username});
    var team = user!["team"];
    var memos = await memoCollection.find({"view": team}).toList();
    var finalList = [];
    for (var element in memos) {
      finalList.add(element);
    }
    return finalList;
  }
}
