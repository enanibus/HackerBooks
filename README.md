# HackerBooks
Práctica Fundamentos de Programacion iOS con Swift - KeepCoding Startup Engineering Master III

### Respuestas a las preguntas y comentarios

#### - Mirar en la ayuda `isKindOfclass` y como usarlo para saber qué devuelve

*La clase `isKindOfClass` sirve para saber si una clase es de un tipo determinado. En nuestro caso la utilizaríamos para saber si recibimos un JSONDictionary o un JSONArray*

#### - ¿En qué otros modos podemos trabajar? ¿is, as?

*Podemos trabajar con el operador de cast 'as'. En esta práctica lo he utilizado como en el ejemplo de clase, con una función `decode` sobrecargada, una para operar sobre las ocurrencias de JSONDictionary para parsear la clase Book y otro para el caso un JSONDictionary? Optional, que lanza un error en el caso de no recibirlo. En otro caso se utiliza en  la función de decodificación para ver si se ha recibido un JSONArray con un opcional maybeArray*

#### - ¿Dónde guardarías las imágenes de portada y los pdfs? 
*`En la carpeta Cache de la Sandbox de la aplicación`*

#### - ¿Cómo harías para persistir la propiedad `isFavorite` de un libro? ¿Se te ocurre más de una forma de hacerlo?

*He optado por guardar un array en NSUserDefaults con el título de los libros que son favoritos. Una vez que arranca la aplicación y al inicializar el Set de libros, se mira si el libro está en el array y se marca como favorito.
Otra forma de hacerlo es guardarlo como un `diccionario de pares <clave, valor> en NSUserDefaults`, como en el curso online de Fundamentos iOS, donde cada entrada sea un libro etiquetado como favorito con valor = true. De la misma forma que antes, se guardan/restauran los favoritos.
Una forma alternativa de guardar los datos de favoritos es utilizar un `fichero que se guarda en la carpeta Documentos de la Sandbox de la aplicación para guardar los favoritos`. Si se cierra la aplicación los datos de favoritos estarán guardados en disco y al abrirla de nuevo se restaura la situación anterior.
También se puede hacer con frameworks de persistencia, siendo uno de ellos `Core Data`*

#### - ¿Cómo harías para notificar que la propiedad `isFavorite` de un libro ha cambiado?
Se pueden utilizar varios métodos, entre otros:

1.- Target -> Action

2.- Delegado

3.- Notificaciones

En el caso de la práctica, LibraryTableViewController es Delegado de BookViewController, y cuando la información de un libro ha cambiado, se hace por las dos vías, vía Delegado y vía Notificaciones.


#### - ¿Cómo enviarías información desde el controlador de un AGTBook a un AGTLibraryTableViewController? ¿Cuál te parece mejor?
Pues como ya se ha comentado en la pregunta anterior, ésas son las posibilidades. La decisión queda a manos del criterio que adopte diseñador de la aplicación, en este caso, he decidido hacerlo con el método de notificaciones

Creo que el método de `Notificaciones` es el mejor ya que permite avisar a todos los objetos que se suscriban a la misma. El patrón de diseño de Delegado está más limitado

#### - Explica el método `reloadData` de *UITableView* ¿Es una aberración desde el punto de vista de rendimiento (volver a cargar datos que en su mayoría ya estaban correctos)?. Explica por qué no es así. ¿Hay una forma alternativa? ¿Cuándo merece la pena usarlo?
Además de que el data source modelo que alimenta la UITableVIew está en local y no hay que descargarlo, tengo entendido que las clase de Cocoa solamente actualizan las celdas que 'caben' en una vista; por ambos motivos no parece desde luego ninguna aberración

#### - ¿Cómo harías para notificar que un usuario ha cambiado en la tabla el libro seleccionado al *AGTSimplePDFVIewController* para su actualización.
En el método viewWillAppear de la clase AGTSimplePDFVIewController se suscribe a las notificaciones con el selector de que un libro haya cambiado y así se actualiza por tanto la vista del pdf

#### - Comentarios

- Sobre la pregunta acerca de cómo informar de cambios entre los controladores de AGTBookViewController y AGTLibraryTableViewController, en el código análogo de clase, el controlador de la tabla informa a su delegado, que es el controlador de AGTBook y además manda una notificación de que ha cambiado el foco del libreo seleccionado. Me gustaría conocer cuál es la mejor solución, si dejar ambas llamadas, quitar la notificación o condicionar a si su delegado está suscrito a notificaciones

- En la parte de implementación del diccionario de libros con la estructura de datos MultiMap he visto que existen librerías como Buckets que permiten incluirla con CocoaPods pero he preferido hacerlo por mí mismo para aprender y por hacerlo con Swift, eso sí, me ha costado un poco por el tema de los opcionales y el casting Array <-> Set. No está implementado, cuando tenga tiempo, implementar el BookDictionary como una clase MultiMap<K, V>

- También he leído que la mejor manera de suscribir/da de baja de notificaciones se hace en los métodos `init o viewDidLoad` para el alta y `deinit` para la baja. En la práctica y en clase lo hemos hecho en viewDidAppear/viewDidDisappear. Quisiera saber cuál es la mejor (creo que al instanciar/ desinstanciar sería mejor) 

- En líneas generales,estoy contento del trabajo realizado, he aprendido muchísimo con esta práctica, y aunque creo que Joven Padawan llego a ser, queda el largo y tortuoso camino de la Fuerza para alcanzar la meta de llegar a ser maestro Jedi


#### - Extras
##### - a ¿Qué funcionalidades le añadiaías antes de subirla a la App Store?
##### - b Ponerle otro nombre con una plantilla
##### - c Usando la plantilla anteriormente descrita, ¿qué otras versiones se te ocurren?. ¿Alguna que se pueda monetizar?

