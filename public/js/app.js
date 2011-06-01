karhu.app = $.sammy(function() {
  this.element_selector = 'body';
  this.objects_cached = false;
  
  this.use(Sammy.Mustache);
  this.use(Sammy.NestedParams);
  this.use(Sammy.JSON);  
  
  this.helpers(karhu.CacheHelper);
  this.helpers(karhu.ApplicationHelper);
  this.helpers(karhu.OfflineHelper);
  this.helpers(karhu.KeyboardHelper);
  this.helpers(karhu.AccessLastItemHelper);
  this.helpers(karhu.CustomValidatorsHelper);
  this.helpers(karhu.LocalesHelper);
  this.helpers(karhu.FilterHelper);
  this.helpers(karhu.SortHelper);
  this.helpers({ store: karhu.config.store });

  karhu.Categories(this);
  karhu.Products(this);
  karhu.CachedActions(this);
  karhu.Locales(this);
  karhu.Session(this);
  karhu.Pages(this);
  
  //
  // NOTE: for this to work sammy needs to send the event context to swap
  //
  //   swap: function(contents) {
  //     return this.app.swap(contents, this);
  //   },
  //
  this.swap = function(content, context) {
    var result = $('.main').html(content);

    context.beautifyInputElements();
    context.adjustElementsToOnlineStatus();
    context.validateForm();
    context.markSortColumn();
    context.updatePagination(context.objectForPagination);
    context.displayHelp(content);

    return result;
  };
  
  this.get('#/', function() {
    this.redirect('#/products');
  });
  
  this.bind('init', function() {
    this.cachePartials();
    this.clearStore();
    this.prepareCancelButtons();
    this.prepareInputFields();
    this.prepareLinks();
    this.initializeCustomValidators();
    this.initializeKeyboardControl();
    this.notifyOfOnlineOfflineStatus();
  });
  
  
  var event_context = this.context_prototype.prototype;
  
  this.before(event_context.clearContextVariables);
  this.before(event_context.markActiveMenuItem);
  this.before(event_context.showLinks);
  this.before({only: {verb: ['post', 'put']}}, event_context.redirectIfCanceled);

  this.around(event_context.initializeLocales);
  this.around(event_context.redirectToLogin);
  this.around(event_context.redirectToLastAccessedItem);
  
  this.after(event_context.saveLastLocation);
});

$(function() {
  karhu.app.run('#/');
  karhu.app.trigger('init');
});