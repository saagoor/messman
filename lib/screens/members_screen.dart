import 'package:flutter/material.dart';
import 'package:mess/models/models.dart';
import 'package:mess/screens/auth/profile_screen.dart';
import 'package:mess/screens/save_member_screen.dart';
import 'package:mess/services/helpers.dart';
import 'package:mess/services/members_service.dart';
import 'package:mess/widgets/list_view_empty.dart';
import 'package:mess/widgets/user/members_circle_avatar.dart';
import 'package:provider/provider.dart';

class MembersScreen extends StatefulWidget {
  static const routeName = '/members';

  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  MembersService membersService;

  Future<void> _loadMembers() async {
    return await membersService.fetchAndSet().catchError((error) {
      return showHttpError(context, error);
    });
  }

  Widget build(BuildContext context) {
    membersService = Provider.of<MembersService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mess Members'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(SaveMemberScreen.routeName);
        },
        child: Icon(Icons.person_add),
      ),
      body: RefreshIndicator(
        child: membersService.items.length <= 0
            ? ListViewEmpty(text: 'Could not load members!')
            : ListView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                itemCount: membersService.items.length,
                itemBuilder: (ctx, i) => MemberListItem(
                  membersService.items[i],
                ),
              ),
        onRefresh: _loadMembers,
      ),
    );
  }
}

class MemberListItem extends StatelessWidget {
  final User member;
  MemberListItem(this.member);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Hero(
          tag: member.id ?? 0,
          child: MembersCircleAvatar(
            imageUrl: member.imageUrl,
            firstChar: member.name[0],
          ),
        ),
        title: Text(member.name),
        subtitle: Text(member.email),
        trailing: PopupMenuButton<MemberActions>(
          itemBuilder: (ctx) => [
            PopupMenuItem(
              child: Text('Edit Member'),
              value: MemberActions.Edit,
            ),
            PopupMenuItem(
              child: Text('Remove Member'),
              value: MemberActions.Remove,
            ),
          ],
        ),
        contentPadding: EdgeInsets.zero,
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProfileScreen.routeName, arguments: member);
        },
      ),
    );
  }
}

enum MemberActions {
  Edit,
  Remove,
  AddDeposit,
  AddExpense,
}
