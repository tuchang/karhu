karhu.Products = function(app) {
  app.get('#/products', function(context) {
    context.ajax_get('/categories', {}, function(categories) {
      context.ajax_get('/products', {}, function(products) {
        products = products.map(function(product) { return new karhu.Product(product, categories); });
        context.partial('templates/products/index.mustache', {products: products});
      });
    });
  });
  
  app.get('#/products/new', function(context) {
    context.handleLastAccess(null, 'last_added_product', function(last_added_product) {
      context.ajax_get('/categories', {}, function(categories) {
        context.objectForValidation = new karhu.Product();
        context.partial('templates/products/new.mustache', new karhu.EditProduct({}, categories, last_added_product));
      });      
    });
  });
  
  app.post('#/products', function(context) {
    context.store.clear('last_added_product');
    context.ajax_post('/products', context.params.product, function() {
      context.flash('product_successfully_created');
      context.redirect('#/products');      
    }, function() {
      context.flash('not_able_to_create_product');
    });
  });

  app.get('#/products/:id/edit', function(context) {
    context.handleLastAccess(context.params, 'last_edited_product', function(last_edited_product) {
      context.ajax_get('/categories', {}, function(categories) {
        context.ajax_get('/products/' + context.params.id, {}, function(product) {
          context.objectForValidation = new karhu.Product();
          context.partial('templates/products/edit.mustache', new karhu.EditProduct(product, categories, last_edited_product));
        });
      });      
    });
  });
  
  app.put('#/products/:id', function(context) {
    context.store.clear('last_edited_product');
    context.ajax_put('/products/' + context.params.id, context.params.product, function() {
      context.flash('product_successfully_updated');
      context.redirect('#/products');
    }, function() {
      context.flash('not_able_to_update_product');    
    });
  });
    
  app.del('#/products/:id', function(context) {
    context.ajax_delete('/products/' + context.params.id, {}, function() {
      context.flash('product_successfully_deleted');
      context.redirect('#/products');      
    }, function() {
      context.flash('not_able_to_delete_product');
    });
  });
};