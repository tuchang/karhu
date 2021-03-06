karhu.app = $.sammy(function(app, context) {
  this.element_selector = 'body';
  this.objects_cached = false;
  
  this.use(Sammy.Mustache, 'mustache');
  this.use(Sammy.NestedParams);
  this.use(Sammy.JSON);  
  
  this.helpers(karhu.CacheHelper);
  this.helpers(karhu.ApplicationHelper);
  this.helpers(karhu.OfflineHelper);
  this.helpers(karhu.KeyboardHelper);
  this.helpers(karhu.AccessLastItemHelper);
  this.helpers(karhu.CustomValidatorsHelper);
  this.helpers(karhu.LocalesHelper);
  this.helpers(karhu.AppFilterHelper);
  this.helpers(karhu.SortHelper);
  this.helpers({ store: karhu.config.store });

  karhu.Categories(this);
  karhu.Products(this);
  karhu.CachedActions(this);
  karhu.Locales(this);
  karhu.Session(this);
  karhu.Pages(this);

  this.swap = function(content) { return $('.main').html(content); };
  
  this.bind('changed', function() {
    this.beautifyInputElements();
    this.adjustElementsToOnlineStatus();
    this.validateForm();
    this.markSortColumn();
    this.updatePaginationLinks();
  });
  
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
  
  this.before(context.markActiveMenuItem);
  this.before(context.changeSearchField);
  this.before(context.showLinks);
  this.before({only: {verb: ['post', 'put']}}, context.redirectIfCanceled);

  this.around(context.updateContextVariables);
  this.around(context.redirectToLogin);
  this.around(context.redirectToLastAccessedItem);  
});

$(function() {
  karhu.i18n = new karhu.I18n(karhu.config.store);
  karhu.app.run('#/');
  karhu.app.trigger('init');
});