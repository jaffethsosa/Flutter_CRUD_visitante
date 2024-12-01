import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_crud_visitante/models/visitante.dart';

class FirestoreService {
  //get coleccion of note
  final CollectionReference visitantesCollection = 
  FirebaseFirestore.instance.collection('notes');

  //CREATE
  Future<void> add(Visitante visitante) {
  return visitantesCollection.add({
      'name': visitante.name,
      'identificacion': visitante.identificacion,
      'hora': visitante.hora,
      'motivo': visitante.motivo,
      'paciente':visitante.paciente,
      'transporte':visitante.transporte
    });
}

  //READ
  Stream<QuerySnapshot>getVisitantes(){
    final visitantesStream = 
    visitantesCollection.orderBy('name', descending: true).snapshots();
    
    return visitantesStream;
  }
  //UPDATE
  Future<void> updateVisitante(String visitID, Visitante newVisitante) {
    return visitantesCollection.doc(visitID).update({
      'name': newVisitante.name,
      'identificacion': newVisitante.identificacion,
      'hora': newVisitante.hora,
      'motivo': newVisitante.motivo,
      'paciente':newVisitante.paciente,
      'transporte':newVisitante.transporte
    });
  }
  
  //DELETE
  Future<void> deleteVisitante(String visitID) {
    return visitantesCollection.doc(visitID).delete();
  }

}