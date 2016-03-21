#modified from fcsa-number
myNumberModule = angular.module('my-number', [])

myNumberModule.directive 'myNumber',
[ () ->
    isNumber = (val) ->
        !isNaN(parseFloat(val)) && isFinite(val)

    # 44 is ',', 45 is '-', 57 is '9' and 47 is '/'
    isNotDigit = (which) ->
        (which < 44 || which > 57 || which is 47)

    controlKeys = [0,8,13] # 0 = tab, 8 = backspace , 13 = enter
    isNotControlKey = (which) ->
      controlKeys.indexOf(which) == -1

    hasMultipleDecimals = (val) ->
      val? && val.toString().split('.').length > 2

    makeIsValid = () ->
        validations = []
            
        (val) ->
            return false unless isNumber val
            return false if hasMultipleDecimals val
            number = Number val
            for i in [0...validations.length]
                return false unless validations[i] val, number
            true
        
    addCommasToInteger = (val) ->
        decimals = `val.indexOf('.') == -1 ? '' : val.replace(/^-?\d+(?=\.)/, '')`
        wholeNumbers = val.replace /(\.\d+)$/, ''
        commas = wholeNumbers.replace /(\d)(?=(\d{3})+(?!\d))/g, '$1,'
        "#{commas}#{decimals}"
   
    adjustNumberScaling = (val) ->
        suffixMultiplier = 
            k: 1000
            K: 1000
            m: 1000000
            M: 1000000
            b: 1000000000
            B: 1000000000
            s: 1000
            n: 10000
            o: 100000000
            c: 1000000000000
        validSuffixes = Object.keys suffixMultiplier
        matchedSuffix = validSuffixes.find (suffix) -> val.endsWith suffix 
        if matchedSuffix
            [val.substr(0, val.length-matchedSuffix.length), suffixMultiplier[matchedSuffix]]
        else
            [val, 1]   
    {
        restrict: 'A'
        require: 'ngModel'
        link: (scope, elem, attrs, ngModelCtrl) ->
            isValid = makeIsValid 

            ngModelCtrl.$parsers.unshift (viewVal) ->
                [noScalingVal, scaleFactor] = adjustNumberScaling viewVal
                noCommasVal = noScalingVal.replace /,/g, ''
                if isValid(noCommasVal) || !noCommasVal
                    ngModelCtrl.$setValidity 'myNumber', true
                    if noCommasVal
                        return noCommasVal*scaleFactor
                    else 
                        return noCommasVal
                else
                    ngModelCtrl.$setValidity 'myNumber', false
                    return undefined

            ngModelCtrl.$formatters.push (val) ->
                return val if !val? || !isValid val
                ngModelCtrl.$setValidity 'myNumber', true
                val = addCommasToInteger val.toString()
                val

            elem.on 'blur', ->
                viewValue = ngModelCtrl.$modelValue
                return if !viewValue? || !isValid(viewValue)
                for formatter in ngModelCtrl.$formatters
                    viewValue = formatter(viewValue)
                ngModelCtrl.$viewValue = viewValue
                ngModelCtrl.$render()

            elem.on 'focus', ->
                elem[0].select()
    }
]
