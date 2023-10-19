/*Nessa parte foram importadas algumas bibliotecas para o desenvolvimento do projeto
cada um acrescentam bibliotecas de extremo valor para a mesma. Para pesquisar sobre cada uma 
utilize o Dart Packages.*/

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';

/*Essas imports se tratam da comunicação entre fillers dentro do Flutter
nesse sentido, você importa o filler que você precisa se comunicar 
durante o funcionamento do programa. Deixando todos os fillers anexados
para a comunicação entre as mesmas.*/

/*Chama a função principal (void main) e chama o "runApp" (que inicia o aplicativo)
para a classe MyApp.*/

void main() => runApp(MyApp());

/*Na classe MyApp foram definidas o tipo de texto, cor de plano de fundo,
dentre outros aspectos. Essa classe é responsável por criar parâmetros gerais para 
o app utilizando a função MaterialApp.*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'DIACSAR';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),

      /*Após os parâmetros definidos, colocamos o "home:" para chamar a classe que deve 
      aparecer na tela inicial do aplicativo.*/

      home: Tela1(),
    );
  }
}
/*Na classe Tela 1 foram colocados o título do projeto utilizando a opção Scaffold
que tem a função de desenvolver e orientar os Widgets de onde devem ficar na tela
e como deveme ficar.*/

class Tela1 extends StatefulWidget {
  const Tela1({super.key});
  @override

  //Construtor para a classe Tela1 desenvolvido para a mesma.

  _Tela1State createState() => _Tela1State();
}

/*Abaixo você irá encontrar a definição de título (utilizando o AppBar) e
alguns Widgets de Texto utilizados para propaganda e explicação do projeto,
também podem ser observados botões simples de direcionamento para outras
classes (que eu também posso chamar de telas).*/

class _Tela1State extends State<Tela1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Projeto D.I.A.C.S.A.R')),
          backgroundColor: Colors.blue,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(''),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(
                    'Olá seja bem-vindo ao Projeto Diacsar, sigla \n'
                    'referente ao projeto: Desenvolvimento e Implantação\n'
                    'de Aplicativo de Controle de Sistema\n'
                    'de Automação Residencial.',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(''),
              ]),
              /*Programação do botão que leva para o Sistema de Comunicação
              ou seja, o BluetoothApp.*/
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                ElevatedButton(
                  child: Text('Sistema de Comunicação',
                      style: TextStyle(fontSize: 25)),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
                  onPressed: () {
                    print('Cliquei Aqui');

                    /*Nessa parte do programa é feito o direcionamento para outra tela
                  quando o botão é precionado.*/

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return BluetoothApp();
                    }));
                  },
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(''),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(
                    'Por favor, siga as instruções dos técnicos para \n'
                    'para melhor aproveitamento do aplicativo e \n'
                    'melhor compreendimento do mesmo.',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(''),
              ]),
              /*Programação do botão que leva para o Sistema Operacional
              ou seja, tela2.*/

              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                ElevatedButton(
                  child: Text('Sistema Operacional',
                      style: TextStyle(fontSize: 26)),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
                  onPressed: () {
                    print('Cliquei Aqui');

                    /*Nessa parte do programa é feito o direcionamento para outra tela
                  quando o botão é precionado.*/

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Tela2();
                    }));
                  },
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(''),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(
                    'Aplicativo desenvolvido pelos Estudantes do \n'
                    'curso Técnico em Eletrônica. \n',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(''),
              ]),
            ])));
  }
}

class Tela2 extends StatefulWidget {
  const Tela2({super.key});
  @override
  _Tela2State createState() =>
      _Tela2State(); //Construtor para a classe Tela2 desenvolvido para a mesma.
}

/*Nessa parte da programação é criada uma classe chamada Tela2 que possui um total de 9
botões utilizados para o envio de comandos do aplicativo para o módulo bluetooth e adaptação
dos comandos para o envio da mesma. Abaixo você pode encontrar uma função if que coordenada isso.

Nessa função é feita a verificação de conexão com o bluetooth, onde se o valor for diferente de 
null (zero) ele pega o valor da variável 'command' (\r\n são utilizados para organização dos 
comandos no terminal) e traduzida para um comando binário chamado Uint8List, e logo em seguida 
enviada pelo bluetooth para o módulo bluetooth que recebe o comando, enviado para o microcontrolador
com a programação em C feita no Arduino IDE e realizada a função. */

class _Tela2State extends State<Tela2> {
  // Função para enviar comandos para o Arduino via Bluetooth
  void sendCommand(String command) async {
    if (_BluetoothAppState.connection != null) {
      try {
        Uint8List data = Uint8List.fromList(utf8.encode(command + "\r\n"));
        _BluetoothAppState.connection!.output.add(data);
        await _BluetoothAppState.connection!.output.allSent;
      } catch (e) {
        // Lidar com erros de comunicação
        print("Erro ao enviar comando: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Projeto D.I.A.C.S.A.R')),
          backgroundColor: Colors.blue,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(''),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                /*Aqui foram organizados 2 botão que controlam os leds 1 e 2, para ligar/desligar
                  o led é usado a mesma lógica para todos. Nesse sentido, quando o botão for
                  precionado, ele vai trocar o valor da varável Command para a string correspondente
                  (alx, x corresponde ao led que você acionou) e logo em seguida é analisado no começo
                  da classe Tela2.*/

                ElevatedButton(
                  onPressed: () {
                    sendCommand('al1');
                    print('al1');
                  },
                  child: Text('Lâmpada 1', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    sendCommand('al2');
                  },
                  child: Text('Lâmpada 2', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                  ),
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                /*Aqui foram organizados 2 botão que controlam os leds 3 e 4, para ligar/desligar
                  o led é usado a mesma lógica para todos. Nesse sentido, quando o botão for
                  precionado, ele vai trocar o valor da varável Command para a string correspondente
                  (alx, x corresponde ao led que você acionou) e logo em seguida é analisado no começo
                  da classe Tela2.*/
                ElevatedButton(
                  onPressed: () {
                    sendCommand('al3');
                    print('al3');
                  },
                  child: Text('Lâmpada 3', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    sendCommand('al4');
                  },
                  child: Text('Lâmpada 4', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                  ),
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                /*Aqui foram organizados 2 botão que controlam os leds 5 e 6, para ligar/desligar
                  o led é usado a mesma lógica para todos. Nesse sentido, quando o botão for
                  precionado, ele vai trocar o valor da varável Command para a string correspondente
                  (alx, x corresponde ao led que você acionou) e logo em seguida é analisado no começo
                  da classe Tela2.*/
                ElevatedButton(
                  onPressed: () {
                    sendCommand('al5');
                  },
                  child: Text('Lâmpada 5', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    sendCommand('al6');
                  },
                  child: Text('Lâmpada 6', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                  ),
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                /*Aqui foi organizado 1 botão que controla o led7, para ligar/desligar
                  o led é usado a mesma lógica para todos. Nesse sentido, quando o botão for
                  precionado, ele vai trocar o valor da varável Command para a string correspondente
                  (alx, x corresponde ao led que você acionou) e logo em seguida é analisado no começo
                  da classe Tela2.*/
                ElevatedButton(
                  onPressed: () {
                    sendCommand('al7');
                  },
                  child: Text('Lâmpada 7', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                  ),
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(''),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                /*Aqui foi organizado 1 botão que controla o motor, para ligar/desligar
                  o motor é usado a mesma lógica para todos. Nesse sentido, quando o botão for
                  precionado, ele vai trocar o valor da varável Command para a string correspondente
                  (alx, x corresponde ao led que você acionou) e logo em seguida é analisado no começo
                  da classe Tela2.*/
                ElevatedButton(
                  onPressed: () {
                    sendCommand('am');
                  },
                  child: Text('Sistema de Ventilação',
                      style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                  ),
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                /*Aqui foi organizado 1 botão que controla a Bomba d'água, para ligar/desligar
                  a bomba é usado a mesma lógica para todos. Nesse sentido, quando o botão for
                  precionado, ele vai trocar o valor da varável Command para a string correspondente
                  (alx, x corresponde ao led que você acionou) e logo em seguida é analisado no começo
                  da classe Tela2.*/
                ElevatedButton(
                  onPressed: () {
                    sendCommand('ab');
                  },
                  child: Text('Sistema de Irrigação',
                      style: TextStyle(fontSize: 21)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                  ),
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(''),
              ]),
            ])));
  }

  @override
  void initState() {
    super.initState();
  }
}

/*Nessa parte do programação, está sendo realizada a parte de identificação dos aparelhos
emparelhados ao dispostivo que se encontra o aplicativo, listagem das mesmas, seleção do 
desejado (que é feita pelo usuário) e toda a parte lógica que irá tornar possível a conexão,
parelhamento e envio de dados pelo módulo bluetooth.

Obs: Para se conectar a aparelhos bluetooth necessita ter em mente que existem dois tipos de bluetooth, 
o bluetooth clássico e o bluetooth ble (Recomendo pesquisar sobre para ver qual tipo se encaixa
no seu caso), nesse trabalho foi utilizado o clássico para a conexão do aplicatico com um 
módulo bluetooth HC-05. A outra observação é que existem vários métodos de rastreamento e 
emparelhamento de um HC-05, pode ser feito usado o endereço do mesmo módulo (que geralmente é 
indentificado como algo parecido a 00:00:00:00:00:00) ou procurando pelos emparelhados com o telefone. 
Nesse caso utilizamos os emparelhados com o telefone. */

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  String connectionStatus = 'Não Conectado';
  static BluetoothConnection?
      connection; // Declare connection como uma variável opcional
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDevice> _devicesList = [];
  static BluetoothDevice? _device;
  static bool _connected = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    bluetoothConnectionState();
  }

  Future<void> bluetoothConnectionState() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } catch (error) {
      print("Erro: $error");
    }

    bluetooth.state.then((state) {
      setState(() {
        _pressed = false;
      });
    });

    if (!mounted) {
      return;
    }

    setState(() {
      _devicesList = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(child: Text("Sistema de Comunicação")),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              "Dispositivos Pareáveis",
              style: TextStyle(
                fontSize: 24,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '  Aparelho:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<BluetoothDevice>(
                  items: _getDeviceItems(),
                  onChanged: (value) => setState(() => _device = value),
                  value: _device,
                ),
                ElevatedButton(
                  onPressed: _pressed ? null : (connectToBluetoothDevice),
                  child: Text(_connected ? 'Desconectado' : 'Conectado'),
                ),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text(''),
          ]),
          Padding(
            padding: const EdgeInsets.all(16.0),
            /*child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                Future show(
                String message, {
                Duration duration: const Duration(seconds: 3),
                }) async {
                await new Future.delayed(new Duration(milliseconds: 100));
                _scaffoldKey.currentState.showSnackBar(
                new SnackBar(
                content: new Text(
                message,
                ),
                duration: duration,
                ),
                );
              ),
            ),*/
          ),
          Text('Status de Conexão: $connectionStatus'),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text(''),
          ]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "Observações: \n Se você não conseguir encontrar o dispositivo \n na lista "
                  "ligue o Bluetooth do seu aparelho, \n emparelhe o dispositivo ao módulo "
                  "bluetooth \n usando a senha '1234' e permita as configurações de localidade "
                  "do aplicativo nas configurações do mesmo.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text(''),
          ]),
        ],
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('Selecione'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? "DEVICE 1"),
          value: device,
        ));
      });
    }
    return items;
  }

  /*Nessa parte do programa é feita a conexão ao aparelho selecionado apertando no 
  botão de 'Conectar', se for conectado algum dispositivo a variável de conexão é 
  alterada para true. Caso contrário, é definida como false. */

  void _connect() {
    if (_device == null) {
      show('Nenhum aparelho selecionado');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth
              .connect(_device!)
              .timeout(Duration(seconds: 10))
              .catchError((error) {
            setState(() => _pressed = false);
          });
          setState(() => _pressed = true);
        }
      });
    }
  }

  /*Nesse caso, se você apertar o botão 'desconectar' ele desconecta o dispotivo emparelhado. */

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _pressed = true);
  }

  void show(String message, {Duration duration = const Duration(seconds: 3)}) {
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
          duration: duration,
        ),
      );
    });
  }

  /*Essa função manda uma mensagem quando algum dispotivo se conecta ao aplicativo.*/

  void _sendOnMessageToBluetooth() {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.write("1");
        show('Dispositivo Conectado (On)');
      }
    });
  }

  /*Essa função manda uma mensagem quando algum dispotivo se desconecta ao aplicativo.*/

  void _sendOffMessageToBluetooth() {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.write("0");
        show('Dispositivo Desconectado (Off)');
      }
    });
  }

  /*Essa parte da programação coordenada a parte de conexão mandando mensagens no terminal
  para demostrar o estado atual do aplicativo e de sua conexão. Ele também possui algumas
  funções lógicas para organizar a conexão Bluetooth que são um pouco complexas, mas sendo
  analisada com um pouco de experiência e conhecimento podem ser desvendados.*/

  Future<void> connectToBluetoothDevice() async {
    try {
      /*Essa parte da programação é responsável pela conexão do aplicativo ao módulo bluetooth.
      Nesse sentido, se quiser fazer com que o aplicativo se conecte diretamente ao HC-05
      você pode simples reformular a programação tirando o _device e substituindo ele pelo 'adress'
      com o endereço do HC-05 (00:00:00:00:00:00). 

      Ex: 
      String address = '98:D3:31:F6:D3:64'; */
      String? address = _device?.address;
      connection = await BluetoothConnection.toAddress(address);
      print('Conectado ao Dispositivo');

      /*Variável de estado que define o estado atual do aplicativo e coordenada 
      seu estado. Nesse sentido, ele mostra como está e altera caso necessário pelo
      programador.*/

      setState(() {
        connectionStatus = 'Conectado';
        _connected = true;
      });

      /*Avalia o estado de conexão que envolve a transferência de dados (comandos) entre 
      o aplicativo e o módulo bluetooth. Nesse caso, ele */

      connection!.input!.listen((Uint8List? data) {
        if (data != null) {
          print('Entrada de Dados: ${String.fromCharCodes(data)}');
          connection!.output.add(data);
          if (String.fromCharCodes(data).contains('!')) {
            connection!.finish();
            print('Desconectado pelo local host');
            setState(() {
              connectionStatus = 'Desconectado';
              _connected = false;
            });
          }
        }
        /*Força outros aparelhos a serem desconectados do módulo bluetooth.
        Obs: Não foi aproveitada essa função dentro do projeto até dado momento, mas na teoria
        seria necessário somente a criação de um botão com a função .onDone em um segundo aplicativo
        que seria desenvolvido para ser um administrador geral. */
      }).onDone(() {
        print('Desconectado por solicitação remota');
        setState(() {
          connectionStatus = 'Desconectado';
          _connected = false;
        });
      });
      /*Mostra na tela uma mensagem de erro em caso de algum erro que não foi calculado
      pelo desenvolvedor do aplicativo. */
    } catch (exception) {
      print('Não é possível conectar, ocorreu uma exceção.');
      setState(() {
        connectionStatus = 'Erro: $exception';
        _connected = false;
      });
    }
  }
}
