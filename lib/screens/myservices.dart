import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:service_app/helper/helper.dart';
import 'package:service_app/models/MyServicesModal.dart';
import 'package:service_app/screens/work_with_us.dart';
import 'package:service_app/services/http_service.dart';

class MyServices extends StatefulWidget {
  const MyServices({Key? key}) : super(key: key);

  @override
  _MyServicesState createState() => _MyServicesState();
}

class _MyServicesState extends State<MyServices> {

  List<MyServicesModal>? serviceData;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async{
    await Http_Service.getMyServicesData().then((data){
      print(data);
      setState(() {
        serviceData = data;
        loading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Services"),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>WorkWithUs()));
            },
            icon: Icon(Icons.add,color: Colors.white,),
          )
        ],
      ),
      body: loading == true ? Center(child: Container( height: 120, width: 120, child: Lottie.asset(LOADING),)):SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: ListView.builder(
              itemCount: serviceData != null ? serviceData!.length : 0,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context,index){
                MyServicesModal myServicesModal = serviceData![index];
                return Card(
                  elevation: 5,
                  child: Container(
                    margin:EdgeInsets.all(10),
                    child: Row(
                      children: [
                        myServicesModal.shopImage != null ? Image.network(IMAGE_PATH+"documents/"+myServicesModal.shopImage,height: 100,width: 100,):Image.asset(IMAGE_PLACEHOLDER_IMAGE,height: 100,width: 100,),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(myServicesModal.serviceType,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,),),
                            SizedBox(height: 10,),
                            myServicesModal.name != null ? Text(myServicesModal.name,style: TextStyle(fontSize: 16),):SizedBox(),
                            myServicesModal.status == "1" ? Text("Approved",style: TextStyle(fontSize: 16,color:Colors.green),): Text("Pending",style: TextStyle(fontSize: 16,color:Colors.yellow),),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
          }),
        ),
      ),
    );
  }
}
