
# Starter code
items = [1,2,3,4,5]

try:
    item = items[6]
    print(item)
except Exception:
    print("wrong", Exception)
    print(Exception.__class__)
    


# ZeroDivisionError
# In math there are rules about dividing by zero. 
# The below code is trying to do just that and will throw a ZeroDivisionError. 
# Add exception handling to return back 0 instead of allowing the error to be thrown.

def divide_by(a, b):
    try:
        return a / b
    except ZeroDivisionError:
        return 0
    except Exception as e:
        print(e, 'Something went wrong!')


ans = divide_by(40, 0)
print(ans)



# FileNotFoundError
# The code below is looking for a file that does not exist.
# Add exception handling to catch this error and return the following "The file could not be found".

# Starter code
try:
    with open('file_does_not_exist.txt', 'r') as file:
        print(file.read())
except Exception as e:
    print("The file could not be found")


# Starter code

with open('file_does_not_exist.txt', 'r') as file:
    print(file.read())

