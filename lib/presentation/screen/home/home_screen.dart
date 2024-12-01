

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_visitante/models/visitante.dart';
import 'package:flutter_crud_visitante/src/firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

   @override
   State<HomeScreen> createState() => _HomeScreenState();
   }
  
  class _HomeScreenState extends State<HomeScreen> {

    final FirestoreService firestoreService = FirestoreService();

    final TextEditingController textController = TextEditingController();
  
  void openBox([String? docID]) {
  // Controladores para los campos de entrada
  TextEditingController nameController = TextEditingController();
  TextEditingController identificacionController = TextEditingController();
  TextEditingController horaController = TextEditingController();
  TextEditingController motivoController = TextEditingController();
  TextEditingController pacienteController = TextEditingController();
  TextEditingController transporteController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(docID == null ? 'Add New Record' : 'Edit Record'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Campos de texto para cada propiedad
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'name'),
            ),
            TextField(
              controller: identificacionController,
              decoration: InputDecoration(labelText: 'identificacion'),
            ),
            TextField(
              controller: horaController,
              decoration: InputDecoration(labelText: 'hora'),
              
            ),
            TextField(
              controller: motivoController,
              decoration: InputDecoration(labelText: 'motivo'),
            ),
            TextField(
              controller: pacienteController,
              decoration: InputDecoration(labelText: 'paciente'),
            ),
            TextField(
              controller: transporteController,
              decoration: InputDecoration(labelText: 'transporte'),
            ),
          ],
        ),
      ),
      actions: [
        // Button to save or update
        ElevatedButton(
          onPressed: () {
            // Verifica que los campos no estén vacíos
            if (nameController.text.trim().isNotEmpty &&
                identificacionController.text.trim().isNotEmpty &&
                horaController.text.trim().isNotEmpty &&
                motivoController.text.trim().isNotEmpty &&
                pacienteController.text.trim().isNotEmpty &&
                transporteController.text.trim().isNotEmpty) {
              
              // Crear o actualizar un visitante según el docID
              if (docID == null) {
 
                Visitante visitante = Visitante(
                  name: nameController.text,
                  identificacion: identificacionController.text,
                  hora: horaController.text,
                  motivo: motivoController.text,
                  paciente: pacienteController.text,
                  transporte: transporteController.text,
                );
                firestoreService.add(visitante);
              } else {
                Visitante visitante = Visitante(
                  name: nameController.text,
                  identificacion: identificacionController.text,
                  hora: horaController.text,
                  motivo: motivoController.text,
                  paciente: pacienteController.text,
                  transporte: transporteController.text,
                );
                firestoreService.updateVisitante(docID, visitante);
              }

              // Limpiar los controladores y cerrar el diálogo
              nameController.clear();
              identificacionController.clear();
              horaController.clear();
              motivoController.clear();
              pacienteController.clear();
              transporteController.clear();
              Navigator.pop(context);
            } else {
              // Mostrar un mensaje si los campos están vacíos
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill in all fields!')),
              );
            }
          },
          child: const Text("Save"),
        ),
        // Button to cancel
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
      ],
    ),
  );
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visitantes')),
      floatingActionButton: FloatingActionButton(
        onPressed: openBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getVisitantes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List visitList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: visitList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = visitList[index];
                String docID = document.id;
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                String name = data['name'];
                String identificacion = data['identificacion'];
                String hora = data['hora'];
                String motivo = data['motivo'];
                String paciente = data['paciente'];
                String transporte = data['transporte'];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(name), // Mostrar el nombre o lo que prefieras
                      subtitle: Text('Hora: $hora\nMotivo: $motivo'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => openBox(docID),
                            icon: const Icon(Icons.settings),
                          ),
                          IconButton(
                            onPressed: () => firestoreService.deleteVisitante(docID),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );

          } else {
            // If there is no data
            return const Center(
              child: Text("No notes yet..."),
            );
          }
        },
      ),
    );
  }
}