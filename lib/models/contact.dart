import 'package:flutter/material.dart';

@immutable
class Contact {
  const Contact({
    required this.contactId,
    required this.authId,
    required this.name,
    required this.email,
    required this.subject,
    required this.content,
    required this.creAt,
  });

  final String contactId;
  final String authId;
  final String name;
  final String email;
  final int subject;
  final String content;
  final DateTime creAt;

  // init
  factory Contact.init({
    required String authId,
    required String name,
    required String email,
    required int subject,
    required String content,
  }) {
    return Contact(
      contactId: '',
      authId: authId,
      name: name,
      email: email,
      subject: subject,
      content: content,
      creAt: DateTime.now(),
    );
  }

  // toFirestore
  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'contactId': contactId,
      'authId': authId,
      'name': name,
      'email': email,
      'subject': subject,
      'content': content,
      'creAt': creAt,
    };
  }

  // copyWith
  Contact copyWith({
    String? contactId,
    String? authId,
    String? name,
    String? email,
    int? subject,
    String? content,
    DateTime? creAt,
  }) {
    return Contact(
      contactId: contactId ?? this.contactId,
      authId: authId ?? this.authId,
      name: name ?? this.name,
      email: email ?? this.email,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      creAt: creAt ?? this.creAt,
    );
  }

  // hashCode
  @override
  int get hashCode =>
      contactId.hashCode ^
      authId.hashCode ^
      name.hashCode ^
      email.hashCode ^
      subject.hashCode ^
      content.hashCode ^
      creAt.hashCode;

  // operator ==
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Contact otherContact = other as Contact;
    return contactId == otherContact.contactId &&
        authId == otherContact.authId &&
        name == otherContact.name &&
        email == otherContact.email &&
        subject == otherContact.subject &&
        content == otherContact.content &&
        creAt == otherContact.creAt;
  }
}
