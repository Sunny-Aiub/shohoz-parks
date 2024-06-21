// ignore_for_file: public_member_api_docs, sort_constructors_first
class Ticket {

  int id;
  String name;
  String phoneNumber;
  int amount;
  int ticketCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic? updatedBy;  dynamic? createdBy;
  
  Ticket({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.amount,
    required this.ticketCount,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
  });
  
}
