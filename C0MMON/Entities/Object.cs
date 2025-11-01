using System;
using System.Dynamic;

namespace P4NTH30N.C0MMON;

public static class Object
{
    public static object ConvertToObjectWithoutPropertiesWithNullValues<T>(this T objectToTransform)
    {
        var type = objectToTransform.GetType();
        var returnClass = new ExpandoObject() as IDictionary<string, object>;
        foreach (var propertyInfo in type.GetProperties())
        {
            var value = propertyInfo.GetValue(objectToTransform);
            var valueIsNotAString = !(value is string && !string.IsNullOrWhiteSpace(value.ToString()));
            if (valueIsNotAString && value != null)
            {
                returnClass.Add(propertyInfo.Name, value);
            }
        }
        return returnClass;
    }
}
