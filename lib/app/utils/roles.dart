// ignore_for_file: constant_identifier_names

enum UserRoles{

  ENTRY_TICKET_SELLER,
  ZONE_TICKET_SELLER,
  TICKET_SCANNER

}

extension UserRolesExt on UserRoles {

  String get name {
    switch (this) {
      case UserRoles.ENTRY_TICKET_SELLER:
        return 'Entry Ticket Seller';
      case UserRoles.ZONE_TICKET_SELLER:
        return 'Zone Ticket Seller';
      case UserRoles.TICKET_SCANNER:
        return 'Ticket Scanner';
      default:
        return "null";
    }
  } }