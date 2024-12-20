import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    String appVer = '1.0.0';
    List kelompok = [
      {
        'Nama': 'Leonardo Denavito J.P',
        'NIM': 213020503030
      },
      {
        'Nama': 'Kevin Ginting',
        'NIM': 213030503151
      },
      {
        'Nama': 'Willy Agustri Djabar',
        'NIM': 213020503067
      },
    ];
    
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: const Text('Tentang'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100,),
              Image.asset(
                      'assets/logo_main_text.png',
                      width: 100,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
              Text('Versi v$appVer', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              const SizedBox(height: 24,),
              SizedBox(
                width: 300,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('Dibuat Oleh', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 8,),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: kelompok.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                tileColor: Colors.white10,
                                shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                leading: const Icon(Icons.person, color: Colors.white, size: 30,),
                                title: Text(kelompok[index]['Nama']),
                                subtitle: Text(kelompok[index]['NIM'].toString()),
                                ),
                            );
                          }
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ]
          ),
        )
      ),
    );
  }
}