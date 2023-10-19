#include <SoftwareSerial.h>

/*Nessa parte foram definidas as entradas/saídas correspondentes a cada componente elétrico usado no projeto onde:
- 'ledXPin' são representados pelos Leds/lâmpadas (x é o número correspondente ao Led da maquete) ;
- 'motorPin' representa o motor/ventilador ;
- 'pumpPin' representa a bomba d'água ;
- 'statusLedPin' representa a verificação de envio de comandos pelo aplicativo por bluetooth ;
- 'bluettothConnected' representa o controle de comandos atráves da conexão estabelecida com o bluetooth ;
- 'SoftwareSerial bluetoothserial' representam os pinos correspondentes a pinagem necessária para o módulo bluetooth HC-05.*/

const int led1Pin = 2;
const int led2Pin = 3;
const int led3Pin = 4;
const int led4Pin = 5;
const int led5Pin = 6;
const int led6Pin = 7;
const int led7Pin = 8;
const int motorPin = 9;
const int pumpPin = 10;
const int statusLedPin = 13;
bool bluetoothConnected = false;

SoftwareSerial bluetoothSerial(11, 12); // TX, RX 

/*Já nessa parte, foi criada uma função de valores inteiros (int) para todos as variáveis Pin com variáveis que ajudaram a 
ter maior controle de ativação/desativação dos componentes elétricos.*/

void setPin(int pin);

unsigned long previousMillis = 0;         //Cria um controle de tempo de Mili-segundos.
unsigned long previousMillisCommand = 0;  //Cria um controle de um tempo de Mili-segundos para os Comandos
const long ledOnInterval = 2000;          //Cria um intervalo de tempo de 2 segundos para o Led de Status.
const long commandInterval = 500;         //Cria um controle de spawn de 0,5 segundos entre um comando e outro.

/*Função que estabelece um valor inicial para cada um dos componentes implantados no projeto. Sendo:
- 'OUTPUT' = Componente com valor inicial de 0 ;
- '(9600)' = Componente com uma Frequência de recebimento e envio de 9600 Hz;
- 'false' = Componente com valor inicial de 0. */

void setup() {

  Serial.begin(9600);
  bluetoothSerial.begin(9600);

  pinMode(led1Pin, OUTPUT);
  pinMode(led2Pin, OUTPUT);
  pinMode(led3Pin, OUTPUT);
  pinMode(led4Pin, OUTPUT);
  pinMode(led5Pin, OUTPUT);
  pinMode(led6Pin, OUTPUT);
  pinMode(led7Pin, OUTPUT);
  pinMode(motorPin, OUTPUT);
  pinMode(pumpPin, OUTPUT);
  pinMode(statusLedPin, OUTPUT);

  bluetoothConnected = false;
}

/*Função que faz toda a analise dos comandos enviados, tempo de resposta de cada, analise da ativação/desativação do
bluetooth e etc... */

void loop() {

  unsigned long currentMillis = millis();  //Define uma variação com tempo de Milli-segundos
  
  //Verifica se há dados disponíveis na porta serial correspondente ao bluetooth (RX = 12 e TX = 11)
  //Se for indentificado algum comando (ou seja, se o valor for maior que 0) ele realiza os comandos abaixo.
  if (bluetoothSerial.available() > 0) {
  
    //A conexão Bluetooth está ativa, então acenda (HIGH) o LED de status e manda que a conexão ocorreu (true)
    digitalWrite(statusLedPin, HIGH);
    bluetoothConnected = true;

    //Faz a leitura do comando tipo Until na porta serial (readStringUntil) e salta uma linha (\r\n).
    String command = bluetoothSerial.readStringUntil('\r\n');
    command.trim();

    /*Nessa parte do comando se encontra a parte de controle dos componentes elétricos pelos comandos enviados pelo aplicativo
    pode-se observar que é feito uma subtração dos tempos para impedir o spawn de comandos (if ... - ... >= ...).*/

    if(currentMillis - previousMillisCommand >= commandInterval){

      Serial.println(command);  //Mostra no Terminal se o comando está sendo recebido e qual comando.

      /*Ambos os comandos funcionam com a mesma lógica, ele primeiro analise se o valor recebido é igual ao valor correspondente
      a string que corresponde a ele (command.equals("xy") e se for, ele manda um valor booleano que se for igual a 1 (== 1) ele
      realiza o comando que para todos os casos será acionar (caso seja enviado uma vez) e desligar (caso seja enviado uma segunda
      vez), junto com uma mensagem no terminal falando que o comando foi realizado (XXX acionado).
      
      Obs: Lembrando que o comando 'command.equals() é um comando em Java que pode ser utilizado em C e C++ pelo Arduino IDE, 
      foi necessário para comparar as strings que eram enviados pelo aplicativo com as necessárias para ativar o comando. '*/

      if (command.equals("am") == 1) {
        setPin(motorPin);
        Serial.println("Motor acionado.");
      } else if (command.equals("ab") == 1) {
        setPin(pumpPin);
        Serial.println("Bomba acionado.");
        delay(2000);
        setPin(pumpPin);
      } else if (command.equals("al1") == 1) {
        setPin(led1Pin);
        Serial.println("LED 1 acionado.");
      } else if (command.equals("al2") == 1) {
        setPin(led2Pin);
        Serial.println("LED 2 acionado.");
      } else if (command.equals("al3") == 1) {
        setPin(led3Pin);
        Serial.println("LED 3 acionado.");
      } else if (command.equals("al4") == 1) {
        setPin(led4Pin);
        Serial.println("LED 4 acionado.");
      } else if (command.equals("al5") == 1) {
        setPin(led5Pin);
        Serial.println("LED 5 acionado.");
      } else if (command.equals("al6") == 1) {
        setPin(led6Pin);
        Serial.println("LED 6 acionado.");
      } else if (command.equals("al7") == 1) {
        setPin(led7Pin);
        Serial.println("LED 7 acionado.");  
      } 
      previousMillisCommand = currentMillis;  //Garante que não haja Spawn nos comandos de Acionar/Desligar
    }
    previousMillis = currentMillis;   //Garante que não haja Spawn na conexão bluetooth.
            
  } else {

     bluetoothConnected = false;  //Apaga o Led de Status caso a conexão Bluetooth não esteja sendo realizada.
    
    }
  
  /*Apaga o Led de Status depois do tempo da diferença entre 'currentMillis' e 'previousMillis' ser maior ou igual 
  do que o tempo do ledOnTnternal. */

  if (currentMillis - previousMillis >= ledOnInterval) {
         digitalWrite(statusLedPin, LOW);
  }
  
}

  /*Função responsável por alternar os estados entre Ligado (High, onde ele vai ser ligado com apenas um toque)
  e Desligado (Low, onde ele vai desligado com dois toques), sempre alterando o valor anterior e mudando seu estado 
  de ligado para desligado, e etc..., dos componentes implementados no circuito nas portas Pin. */

void setPin(int pin){
  int currentPower = digitalRead(pin);
  digitalWrite(pin, !currentPower);
}

  /*A função unbinarize converte uma string de dados binários em uma string de caracteres (nesse caso, a string de 
  caracteres corresponde ao comando enviado pelo aplicativo para o microcontrolador), dividindo a string binária 
  em grupos de 8 caracteres, cada grupo representando um byte de dados. Em seguida, converte cada grupo binário 
  em seu equivalente decimal e, finalmente, adiciona o caractere correspondente à string de resultado. Ou seja, 
  ele converte o valor binário escrito em Uint8List, que foi usado para enviar o comando para o microncontrolador pelo app, 
  em um valor decimal correspondente ao valor que ativa os comandos no microcontrolador, da programação do arduino.

  Ex: "al1" (programação aplicativo) --> 1011.1110 (binário enviado para o HC-05) --> "al1" ("traduzido" pelo 'umbinarize').
  
  Obs: O valor binário utilizado no exemplo é representativo. */

String unbinarize(String binaryString) {
  String result = "";
  for (int i = 0; i < binaryString.length(); i += 8) {
    String byteString = binaryString.substring(i, i + 8);
    char byteValue = strtol(byteString.c_str(), NULL, 2);
    result += byteValue;
  }
  return result;
}
