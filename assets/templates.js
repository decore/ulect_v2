angular.module('app-templates', ['auth/login.html', 'auth/register.html', 'home.html', 'user/messages.html']);

angular.module("auth/login.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("auth/login.html",
    "<alert class=\"alert\" ng-repeat=\"error in errors\" type=\"danger\">{{error.err}}</alert>\n" +
    "<form name=\"registerForm\" class=\"form-signin\" novalidate>\n" +
    "  <div class=\"control-group\">\n" +
    "    <input type=\"email\" class=\"form-control\" placeholder=\"email\" name=\"email\" ng-model=\"user.email\" required>\n" +
    "    <div ng-show=\"registerForm.email.$dirty\" ng-messages=\"registerForm.email.$error\">\n" +
    "      <div ng-message=\"required\">\n" +
    "        You forgot the email address.\n" +
    "      </div>\n" +
    "      <div ng-message=\"email\">\n" +
    "        That is not a well formed email address.\n" +
    "      </div>\n" +
    "    </div>\n" +
    "  </div>\n" +
    "  <div class=\"control-group\">\n" +
    "    <input type=\"password\" class=\"form-control\" placeholder=\"password\" name=\"password\" ng-model=\"user.password\" required>\n" +
    "    <div ng-show=\"registerForm.password.$dirty\" ng-messages=\"registerForm.password.$error\">\n" +
    "      <div ng-message=\"required\">\n" +
    "        You forgot the password.\n" +
    "      </div>\n" +
    "    </div>\n" +
    "  </div>\n" +
    "\n" +
    "  <input type=\"submit\" class=\"btn btn-lg btn-primary btn-block\" ng-click=\"login()\" value=\"Login\" />\n" +
    "</form>");
}]);

angular.module("auth/register.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("auth/register.html",
    "<form name=\"registerForm\" class=\"form-signin\" novalidate>\n" +
    "  <div class=\"control-group\">\n" +
    "    <input type=\"email\" class=\"form-control\" placeholder=\"email\" name=\"email\" ng-model=\"user.email\" required>\n" +
    "    <div ng-show=\"registerForm.email.$dirty\" ng-messages=\"registerForm.email.$error\">\n" +
    "      <div ng-message=\"required\">\n" +
    "        You forgot the email address.\n" +
    "      </div>\n" +
    "      <div ng-message=\"email\">\n" +
    "        That is not a well formed email address.\n" +
    "      </div>\n" +
    "    </div>\n" +
    "  </div>\n" +
    "  <div class=\"control-group\">\n" +
    "    <input type=\"password\" class=\"form-control\" placeholder=\"password\" name=\"password\" ng-model=\"user.password\" required>\n" +
    "    <div ng-show=\"registerForm.password.$dirty\" ng-messages=\"registerForm.password.$error\">\n" +
    "      <div ng-message=\"required\">\n" +
    "        You forgot the password.\n" +
    "      </div>\n" +
    "    </div>\n" +
    "  </div>\n" +
    "  <div class=\"control-group\">\n" +
    "    <input type=\"password\" class=\"form-control\" placeholder=\"confirm password\" name=\"confirmpassword\" ng-model=\"user.confirmPassword\" required>\n" +
    "    <div ng-show=\"registerForm.confirmpassword.$dirty\" ng-messages=\"registerForm.confirmpassword.$error\">\n" +
    "      <div ng-message=\"required\">\n" +
    "        You forgot the password confirmation.\n" +
    "      </div>\n" +
    "    </div>\n" +
    "  </div>\n" +
    "\n" +
    "  <input type=\"submit\" class=\"btn btn-lg btn-primary btn-block\" ng-click=\"register()\" value=\"Create Account\" />\n" +
    "</form>");
}]);

angular.module("home.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("home.html",
    "<div class=\"container\">\n" +
    "  <div class=\"jumbotron\">\n" +
    "    <h1>Angular messages!</h1>\n" +
    "\n" +
    "    <h2>Welcome to our demo of Sails + Angular + JWT</h2>\n" +
    "    <a href=\"#/register\" class=\"btn btn-lg btn-success\">Try it!</a>\n" +
    "  </div>\n" +
    "</div>");
}]);

angular.module("user/messages.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("user/messages.html",
    "<div class=\"container\">\n" +
    "  <div class=\"row\">\n" +
    "    <ul class=\"col-md-4 list-group\">\n" +
    "      <li class=\"list-group-item\" ng-repeat=\"message in messages\">\n" +
    "        {{message.body}}\n" +
    "        <span class=\"badge\">\n" +
    "          <span class=\"delete-button\" ng-click=\"deleteMessage(message)\">X</span>\n" +
    "        </span>\n" +
    "      </li>\n" +
    "    </ul>\n" +
    "\n" +
    "    <form name=\"newMessageForm\" novalidate class=\"col-md-4 form-inline\">\n" +
    "      <div class=\"input-group\">\n" +
    "        <input class=\"form-control\" type=\"text\" name=\"body\" ng-model=\"newMessage\" placeholder=\"New message\">\n" +
    "        <span class=\"input-group-btn\">\n" +
    "          <button class=\"btn btn-default btn-primary\" ng-click=\"createMessage()\">Create Message</button>\n" +
    "        </span>\n" +
    "      </div>\n" +
    "    </form>\n" +
    "  </div>\n" +
    "</div>");
}]);
