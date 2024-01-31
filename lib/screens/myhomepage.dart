import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Product?> getProduct() async {
    var barcode = '4056489043379';

    final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      language: OpenFoodFactsLanguage.SPANISH,
      fields: [ProductField.ALL],
      version: ProductQueryVersion.v3,
    );
    final ProductResultV3 result =
        await OpenFoodAPIClient.getProductV3(configuration);

    if (result.status == ProductResultV3.statusSuccess) {
      return result.product;
    } else {
      throw Exception('product not found, please insert data for $barcode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Producto'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              var product = await getProduct();

              if (product != null) {
                // Muestra la información del producto
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Información del Producto'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nombre del Producto: ${product.productName}'),
                          Text('Ingredientes: ${product.ingredientsText}'),
                          Text(
                              'Alergenos: ${product.allergens?.names?.join(', ') ?? "No especificado"}'),
                          SizedBox(
                            height: 30,
                          ),
                          product.imageFrontUrl != null
                              ? Image.network(product.imageFrontUrl!,
                                  height: 300, width: 300)
                              : Text('Imagen no disponible'),

// Puedes agregar más líneas para otros idiomas según sea necesario

                          // Puedes agregar más detalles según sea necesario
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cerrar'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Producto no encontrado'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cerrar'),
                        ),
                      ],
                    );
                  },
                );
              }
            } catch (e) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text('Ocurrió un error al buscar el producto: $e'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cerrar'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Text('Buscar Producto'),
        ),
      ),
    );
  }
}
