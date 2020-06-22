import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezal/raw_materials_page.dart';

import 'data/moor_filename.dart';

class ContainerTaskIzbPage extends StatefulWidget {
  @override
  _ContainerTaskIzbPage createState() => _ContainerTaskIzbPage();
}

class _ContainerTaskIzbPage extends State<ContainerTaskIzbPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Контейнеры'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildTaskList(context)),
            // NewTaskInput(),
          ],
        ));
  }

  StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
    final database = Provider.of<TezAlDb>(context);
    return StreamBuilder(
      stream: database.watchAllTasks(),
      builder: (context, AsyncSnapshot<List<Task>> snapshot) {
        final tasks = snapshot.data ?? List();

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_, index) {
            final itemTask = tasks[index];
            return _buildListItem(itemTask, database);
          },
        );
      },
    );
  }

  Widget _buildListItem(Task itemTask, TezAlDb database) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Удалить',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => database.deleteTask(itemTask),
        )
      ],
      child: Container(
        decoration: BoxDecoration(color: Colors.orange),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          leading: Container(
            padding: EdgeInsets.only(right: 12),
            child: Icon(
              Icons.category,
              color: Colors.black,
            ),
          ),
          title: Text(
            '${itemTask.name} ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            _container(itemTask.containerId);
            Navigator.of(context).pop();
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new RawMaterialScreen()));
          },
        ),
      ),
    );
  }
}

_container(int id) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setInt("container", id);
}

class NewTaskInput extends StatefulWidget {
  const NewTaskInput({
    Key key,
  }) : super(key: key);

  @override
  _NewTaskInputState createState() => _NewTaskInputState();
}

class _NewTaskInputState extends State<NewTaskInput> {
  DateTime newTaskDate;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTextField(context),
          _buildDateButton(context),
        ],
      ),
    );
  }

  Expanded _buildTextField(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: 'Task Name'),
        onSubmitted: (inputName) {
          final database = Provider.of<TezAlDb>(context);
          final task = Task(
            containerId: 1,
            name: inputName,
          );
          database.insertTask(task);
          resetValuesAfterSubmit();
        },
      ),
    );
  }

  IconButton _buildDateButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.calendar_today),
      onPressed: () async {
        newTaskDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2010),
          lastDate: DateTime(2050),
        );
      },
    );
  }

  void resetValuesAfterSubmit() {
    setState(() {
      newTaskDate = null;
      controller.clear();
    });
  }
}
