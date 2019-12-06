import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();
    return MaterialApp(
      title: "Bem-vindo ao Flutter",
      home: RandomWords(),
    );
  }
}

//class RandomWordsState extends State<RandomWords> {

//}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {

  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>(); // armazena as palavras favoritas
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  Widget _buildSuggestions(){
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i){

        if(i.isOdd){
          return Divider();
        }
        final int index = i~/2;

        if(index >= _suggestions.length){
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buidRow(_suggestions[index]);
      },
    );
  }

  Widget _buidRow(WordPair pair){

    final bool alreadySaved = _saved.contains(pair);      // verifica se as palavras ainda não foram adicionadas

    return ListTile(
      title: Text(pair.asPascalCase,
      style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if(alreadySaved){
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
              (WordPair pair) {
                return ListTile(
                  title: Text(pair.asPascalCase,
                  style: _biggerFont,
                  ),
                );

              },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          )
          .toList();

          return Scaffold(
            appBar: AppBar(
              title: Text("Sugestões salvas"),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final WordPair wordPair = WordPair.random();
    return Scaffold(
      appBar: AppBar(
        title: Text("Startup Name Generator"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved,),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}

