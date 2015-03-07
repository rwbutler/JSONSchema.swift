//
//  JSONSchema.swift
//  JSONSchema
//
//  Created by Kyle Fuller on 07/03/2015.
//  Copyright (c) 2015 Cocode. All rights reserved.
//

import Foundation

/// Returns a set of validators for a schema and document
func validators(schema:[String:AnyObject]) -> [Validator] {
  var validators = [Validator]()

  if let type = schema["type"] as? String {
    validators.append(validateType(type))
  } else if let type = schema["type"] as? [String] {
    validators.append(validateType(type))
  }

  // String

  if let maxLength = schema["maxLength"] as? Int {
    validators.append(validateMaximumLength(maxLength))
  }

  if let minLength = schema["minLength"] as? Int {
    validators.append(validateMinimumLength(minLength))
  }

  if let pattern = schema["pattern"] as? String {
    validators.append(validatePattern(pattern))
  }

  // Numerical

  if let multipleOf = schema["multipleOf"] as? NSNumber {
    validators.append(validateMultipleOf(multipleOf))
  }

  if let minimum = schema["minimum"] as? NSNumber {
    validators.append(validateMinimum(minimum, schema["exclusiveMinimum"] as? Bool))
  }

  if let maximum = schema["maximum"] as? NSNumber {
    validators.append(validateMaximum(maximum, schema["exclusiveMaximum"] as? Bool))
  }

  // Array

  if let minItems = schema["minItems"] as? Int {
    validators.append(validateArrayLength(minItems, >=))
  }

  if let maxItems = schema["maxItems"] as? Int {
    validators.append(validateArrayLength(maxItems, <=))
  }

  if let uniqueItems = schema["uniqueItems"] as? Bool {
    if uniqueItems {
      validators.append(validateUniqueItems)
    }
  }

  return validators
}

public func validate(document:AnyObject, schema:[String:AnyObject]) -> Bool {
  return filter(validators(schema)) { validator in
    return !validator(document)
  }.count == 0
}
