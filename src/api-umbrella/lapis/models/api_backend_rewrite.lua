local json_null = require("cjson").null
local model_ext = require "api-umbrella.utils.model_ext"
local t = require("resty.gettext").gettext
local validation_ext = require "api-umbrella.utils.validation_ext"

local validate_field = model_ext.validate_field
local validate_uniqueness = model_ext.validate_uniqueness

local ApiBackendRewrite
ApiBackendRewrite = model_ext.new_class("api_backend_rewrites", {
  as_json = function(self)
    return {
      id = self.id or json_null,
      matcher_type = self.matcher_type or json_null,
      http_method = self.http_method or json_null,
      frontend_matcher = self.frontend_matcher or json_null,
      backend_replacement = self.backend_replacement or json_null,
    }
  end,
}, {
  authorize = function()
    return true
  end,

  validate = function(_, data)
    local errors = {}
    validate_field(errors, data, "api_backend_id", validation_ext.string:minlen(1), t("can't be blank"))
    validate_field(errors, data, "matcher_type", validation_ext:regex("^(route|regex)$", "jo"), t("is not included in the list"))
    validate_field(errors, data, "http_method", validation_ext:regex("^(any|GET|POST|PUT|DELETE|HEAD|TRACE|OPTIONS|CONNECT|PATCH)$", "jo"), t("is not included in the list"))
    validate_field(errors, data, "frontend_matcher", validation_ext.string:minlen(1), t("can't be blank"))
    validate_field(errors, data, "backend_replacement", validation_ext.string:minlen(1), t("can't be blank"))
    validate_field(errors, data, "sort_order", validation_ext.number, t("can't be blank"))
    validate_uniqueness(errors, data, "frontend_matcher", ApiBackendRewrite, {
      "api_backend_id",
      "matcher_type",
      "http_method",
      "frontend_matcher",
    })
    validate_uniqueness(errors, data, "sort_order", ApiBackendRewrite, {
      "api_backend_id",
      "sort_order",
    })
    return errors
  end,
})

return ApiBackendRewrite
