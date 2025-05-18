import 'package:certificat_management/bindings/auth_binding.dart';
import 'package:certificat_management/bindings/certificat_binding.dart';
import 'package:certificat_management/bindings/maison_binding.dart';
import 'package:certificat_management/bindings/personne_binding.dart';
import 'package:certificat_management/bindings/quartier_binding.dart';
import 'package:certificat_management/controllers/auth_controller.dart';
import 'package:certificat_management/controllers/quartier_controller.dart';
import 'package:certificat_management/pages/auth/login_page.dart';
import 'package:certificat_management/pages/auth/register_page.dart';
import 'package:certificat_management/pages/certificat/list_page.dart';
import 'package:certificat_management/pages/home_page.dart';
import 'package:certificat_management/pages/maison/list_page.dart';
import 'package:certificat_management/pages/personne/personne_list_page.dart';
import 'package:certificat_management/pages/quartier/list_page.dart';
import 'package:certificat_management/utils/emoticon_face.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:certificat_management/app_pages.dart';
import 'package:certificat_management/service/app_binding.dart';
// import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/date_symbol_data_local.dart'; // important

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr', null); // Initialise les données pour le français
  // Get.put(QuartierController()); // Enregistre le controller
  runApp(MyApp());
}


// class MyApp extends StatelessWidget {
//   final AuthController authController = Get.put(AuthController());

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Gestion Certificats',
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//         scaffoldBackgroundColor: Colors.white,
//         textTheme: const TextTheme(
//           bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 16),
//         ),
//       ),
//       home: Obx(() {
//         if (authController.isLoading.value) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//         return authController.currentUser.value != null ? LoginPage() : HomePage();
//       }),
//     );
//   }
// }









class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion Certificats',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        // scaffoldBackgroundColor: Colors.grey[100],
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 16),
        ),
      ),
      home:   Acceuil(),
      // home:   LoginPage(),
    );
  }
}





//Mon acceuil predefinit

class Acceuil extends StatelessWidget {
  const Acceuil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 80, 189),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: "historique"),
        ]
      
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                
                children: [
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("hey🖖, Mamadou",
                       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
                      ),
                      SizedBox(height: 5,),
                      Text("04, Mai 2025",
                       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[200], fontSize: 16),
                      ),
                    ],
                  ),
                  // notification
                  InkWell(
                    onTap: () => Get.to(() => LoginPage(), binding: AuthBinding()),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(12)
                      ),
                      padding: EdgeInsets.all(12),
                      
                      child: Icon(Icons.notification_important, size: 26, color: Colors.white,),
                    ),
                  ),
              
                  ],),
              
                  SizedBox(height: 25),
                  // barre de recherche
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                    
                      Icon(Icons.search,color: Colors.white,),
                      SizedBox(width: 5,),
                      Text("Rechercher",style: TextStyle(color: Colors.white,),)
                    ],),
                  ),
                  SizedBox(height: 25,),
                  // mes emotions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text("Quesque vous voulez ?", 
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                    Icon(Icons.more_horiz, color: Colors.white,)
                  ],),
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    // sourire
                    Column(
                      children: [
                        EmoticonFace(emoticonFace: '12', onTap: null,),
                        SizedBox(height: 10,),
                        Text("Quartier", style: TextStyle(color: Colors.white),)
                        
                      ],
                    ),
                    // triste
                    Column(
                      children: [
                        EmoticonFace(emoticonFace: '😔', onTap: null,),
                        SizedBox(height: 10,),
                        Text("triste", style: TextStyle(color: Colors.white),)
                        
                      ],
                    ),
              
                    // doute
                    Column(
                      children: [
                        EmoticonFace(emoticonFace: '🤨', onTap: null,),
                        SizedBox(height: 10,),
                        Text("doute", style: TextStyle(color: Colors.white),)
                        
                      ],
                    ),
                    // doute
                    Column(
                      children: [
                        EmoticonFace(emoticonFace: '🤨', onTap: (){Get.to(HomePage());}),
                        SizedBox(height: 10,),
                        Text("doute", style: TextStyle(color: Colors.white),)
                        
                      ],
                    ),
              
                  ],),
              ],),
            ),
            SizedBox(height: 25,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(75), topRight: Radius.circular(75)),
                  color: Colors.grey[300]
                ),
                child: Center(
                  child: Column(
                    children: [
                      // mes fonctionnalites
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text("Mes Fonctionalites", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        ), 
                        // Icon(Icons.more_horiz_outlined)
                      ],),
                      
                      //mes cards
                      Text("data"),
                      SizedBox(height: 25,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCardIcon(icon: Icons.location_city,
                            title: 'Quartiers',
                            onTap: () => Get.to(() => QuartierListPage(), binding: QuartierBinding()),
                            color: Colors.teal,
                          ),
                          _buildCardIcon(
                            icon: Icons.home,
                            title: 'Maisons',
                            onTap: () => Get.to(() => MaisonListPage(), binding: MaisonBinding()),

                            color: Colors.teal,
                          ),
                        ],
                      ),
                      SizedBox(height: 25,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCardIcon(
                            icon: Icons.person,
                            title: 'Propriétaires',
                            onTap: () => Get.to(() => PersonneListPage(), binding: PersonneBinding()),
                            color: Colors.teal,
                          ),
                          _buildCardIcon(
                            icon: Icons.description,
                            title: 'certificats',
                            onTap: () => Get.to(() => CertificatListPage(), binding: CertificatBinding()),

                            color: Colors.teal,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    
  }
}

class _buildCardIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;
  
  const _buildCardIcon({
    super.key,
     required this.icon, required this.title, required this.onTap, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    splashColor: Colors.blue.withOpacity(0.2),
    child: Container(
      height: 130,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [ const Color.fromARGB(23, 33, 149, 243).withOpacity(0.9), const Color.fromARGB(0, 19, 85, 140).withOpacity(0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red..withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
                        );
  }
}

// Widget _buildFeatureCard({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     required Color color,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(20),
//       splashColor: color.withOpacity(0.2),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           gradient: LinearGradient(
//             colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.3),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 50, color: Colors.white),
//             const SizedBox(height: 12),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }












// class Acceuil extends StatelessWidget {
//   const Acceuil({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Certificat de Domicile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         backgroundColor: Colors.indigo,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//             child: Column(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(15),
//                   child: Image.asset(
//                     'assets/images/certif.jpg',
//                     height: 400,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 const Text(
//                   'Bienvenue sur la plateforme numérique de demande et gestion des certificats de domicile. Facile, rapide et efficace !',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 23,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                     height: 1.4,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 80),
//             child: SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   // Get.toNamed('/home');
//                   print("go to home page");
//                   Get.to(HomePage());
//                 },
//                 icon: const Icon(Icons.document_scanner, size: 30,color: Color.fromARGB(236, 205, 192, 51)),
//                 label: const Text(
//                   'Générer un certificat',
//                   // style: TextStyle(fontSize: 16),
//                   style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold)
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   backgroundColor: Colors.indigoAccent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   elevation: 9,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
