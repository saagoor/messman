import 'package:flutter/material.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/services/members_service.dart';
import 'package:provider/provider.dart';

class MemberSelector extends StatelessWidget {
  final String labelText;
  final int initialId;
  final Function(int id) onChanged;
  MemberSelector({
    this.labelText,
    @required this.initialId,
    @required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    final membersService = Provider.of<MembersService>(context);
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: labelText ?? 'Member',
        prefixIcon: Icon(Icons.person_outline),
      ),
      value: initialId ?? Provider.of<AuthService>(context).user?.id,
      items: membersService.items
          .map((member) => DropdownMenuItem<int>(
                child: Row(
                  children: <Widget>[
                    Text(member.name ?? 'MessMan User'),
                  ],
                ),
                value: member.id,
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
