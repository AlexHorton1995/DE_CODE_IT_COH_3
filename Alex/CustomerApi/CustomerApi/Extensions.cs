using CustomerApi.Models;

namespace CustomerApi
{
    static class Extensions
    {
        public static bool FieldIsSame<T>(T original, T newVal)
        {
            if (original.Equals(newVal))
            {
                return true; //they are the same
            }
            else
            {
                return false;
            }
        }
    }
}
