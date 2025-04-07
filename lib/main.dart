import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://stmuqtudlxowcyctcfov.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN0bXVxdHVkbHhvd2N5Y3RjZm92Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQwMDMzNjQsImV4cCI6MjA1OTU3OTM2NH0.SiTCShwKe84CLGyoa651iJ07mOwZvmAUjSuLF-EiP6s',
  );
  // Get a reference your Supabase client

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Supabase CRUD',
      home: CrudPage(),
    );
  }
}

class CrudPage extends StatefulWidget {
  @override
  _CrudPageState createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController nameController = TextEditingController();

  List<dynamic> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    final res = await supabase.from('table1').select();
    setState(() {
      data = res;
      isLoading = false;
    });
  }

  Future<void> createData(String name) async {
    await supabase.from('table1').insert({'name': name});
    nameController.clear();
    fetchData();
  }

  Future<void> updateData(int id, String name) async {
    await supabase.from('table1').update({'name': name}).eq('id', id);
    fetchData();
  }

  Future<void> deleteData(int id) async {
    await supabase.from('table1').delete().eq('id', id);
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Supabase CRUD')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Create
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'نام'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    createData(nameController.text);
                  },
                  child: Text('افزودن'),
                )
              ],
            ),
            SizedBox(height: 20),
            // Read & Actions
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        final id = item['id'];
                        final name = item['name'];

                        final TextEditingController editController =
                            TextEditingController(text: name);

                        return Card(
                          child: ListTile(
                            title: Text(name),
                            subtitle: Text('ID: $id'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text('ویرایش'),
                                        content: TextField(
                                          controller: editController,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              updateData(
                                                  id, editController.text);
                                              Navigator.pop(context);
                                            },
                                            child: Text('ذخیره'),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => deleteData(id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
