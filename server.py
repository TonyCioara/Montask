from flask import Flask, request, make_response
from flask_restful import Resource, Api
from pymongo import MongoClient
from bson.objectid import ObjectId
from bson.json_util import dumps
import bcrypt
import json
import pdb

def validate_auth(email, password):
    user_collection = app.db.Users
    # pdb.set_trace()
    user = user_collection.find_one({'email': email})

    if user is None:
        return False
    else:
        # check if the hash we generate based on auth matches stored hash
        encodedPassword = password.encode('utf-8')

        if bcrypt.hashpw(encodedPassword, user['password']) == user['password']:
            return True
        else:
            return False

def authenticated_request(func):
    def wrapper(*args, **kwargs):
        auth = request.authorization


        if not auth or not validate_auth(auth.username, auth.password):
            return ({'error': 'Basic Auth Required.'}, 401, None)

        return func(*args, **kwargs)

    return wrapper

class JSONEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, ObjectId):
            return str(o)
        return json.JSONEncoder.default(self, o)


app = Flask(__name__)
app.bcrypt_rounds = 12
mongo = MongoClient('localhost', 27017)
app.db = mongo.Monsters
app.bcrypt_rounds = 12
api = Api(app)



class Friend_Monsters(Resource):
    @authenticated_request
    def get(self):
        monster_collection = app.db.Monsters
        user_collection = app.db.Users
        auth = request.authorization
        user = user_collection.find_one({'email': auth['username']})
        monsters = list(monster_collection.find({'user_email': {'$in': user['friends']}}))
        if monsters == []:
            not_found_msg = {'error': 'monsters not found'}
            json_not_found = json.dumps(not_found_msg)
            return (json_not_found, 400, None)
        json_monsters = json.loads(dumps(monsters))
        return (json_monsters, 200, None)


class Friends(Resource):
    @authenticated_request
    def get(self):
        user_collection = app.db.Users
        auth = request.authorization
        
        user = user_collection.find_one({'email': auth['username']})
        friends = list(user_collection.find({'email': { "$in": user['friends']}}))

        if friends == []:
            not_found_msg = {'error': 'friends not found'}
            json_not_found = json.dumps(not_found_msg)
            return (json_not_found, 400, None)
        json_friends = json.loads(dumps(friends))
        return (json_friends, 200, None)

class User(Resource):
    """This get request is used when we log in a user"""
    @authenticated_request
    def get(self):
        #Getting the collection
        user_collection = app.db.Users
        auth = request.authorization
        user = user_collection.find_one({'email': auth['username']})
        #We need to pop it, with the GET request, we can receive the hashed password, but we can't send serialize it back to JSON, thus, we have to pop it. But the hashed password is still in our database.
        user.pop('password')
        if user == None:
            not_found_msg = {'error': 'user not found'}
            json_not_found = json.dumps(not_found_msg)
            return (json_not_found, 400, None)

        return (user, 200, None)

    def post(self):
      #in our client, we're going to have to send the required information through the body
      #We need a body function in the client
      new_user = request.json
      users_collection = app.db.Users


      if ('password' in new_user and 'email' in new_user and 'level' in new_user and 'friends' in new_user):
          password = new_user['password']
          encodedPassword = password.encode('utf-8')

          hashed = bcrypt.hashpw(
          encodedPassword, bcrypt.gensalt(app.bcrypt_rounds)
          )
          new_user['password'] = hashed
          new_user['username'] = new_user['email']
          if new_user['friends'] is None:
              new_user['friends'] = []

          #After inserting an obj into the database, it returns to us the object ID
          #So we use the id in our find_one function only after it has been posted
          #Regularly, how would we be able to find a user based off of it's id?
          result = users_collection.insert_one(new_user)
          user_object = users_collection.find_one({"_id": ObjectId(result.inserted_id)})
          user_object.pop('password')
          return (user_object, 200, None)

      error_dict = {'error': 'Missing Parameters'}


      return (error_dict, 400, None)

    @authenticated_request
    def patch(self):
      auth = request.authorization
      user_collection = app.db.Users
      changing_properties = request.json
      if 'level' in changing_properties:
          user_collection.update_one({'email': auth['username']}, {'$set': {'level': changing_properties['level']}})
          return ({"success": "You have successfully updated " + str(user_collection.find_one({'email': auth['username']}))}, 200, None)
      error_msg = {'error': 'invalid parameters'}
      json_error_msg = json.dumps(error_msg)
      return (json_error_msg, 400, None)




class Monster(Resource):
    """docstring for Monster."""
    @authenticated_request
    def get(self):
        monster_collection = app.db.Monsters
        auth = request.authorization
        monsters = list(monster_collection.find({'user_email': auth['username']}))
        if monsters is None:
            not_found_msg = {'error': 'monsters not found'}
            json_not_found = json.dumps(not_found_msg)
            return (json_not_found, 400, None)
        # encoded_trips = dumps(result_trips)

        json_monsters = json.loads(dumps(monsters))
        return (json_monsters, 200, None)

    @authenticated_request
    def post(self):
        monster_collection = app.db.Monsters
        monster_param = request.json
        if 'name' in monster_param and 'power' in monster_param and 'special_name' in monster_param and 'special_power' in monster_param and 'health' in monster_param and 'user_email' in monster_param:
            new_monster = monster_collection.insert_one(monster_param)
            inputted_monster = monster_collection.find_one({"_id": ObjectId(new_monster.inserted_id)})
            return (inputted_monster, 200, None)
        error_msg = {'error': 'invalid parameters'}
        json_error_msg = json.dumps(error_msg)
        return (json_error_msg, 400, None)




class Task(Resource):
    """docstring for Task."""
    @authenticated_request
    def get(self):
        task_collection = app.db.Tasks
        auth = request.authorization
        tasks = list(task_collection.find({'user_email': auth['username']}))
        if tasks is None:
            not_found_msg = {'error': 'tasks not found'}
            json_not_found = json.dumps(not_found_msg)
            return (json_not_found, 400, None)


        json_tasks = json.loads(dumps(tasks))
        return (json_tasks, 200, None)

    @authenticated_request
    def post(self):
        task_collection = app.db.Tasks
        task_param = request.json
        auth = request.authorization
        if 'name' in task_param and 'description' in task_param and 'task_length' in task_param and 'completion_percentage' in task_param and 'time_created' in task_param:
            task_param['user_email'] = auth['username']
            new_task = task_collection.insert_one(task_param)
            inputted_task = task_collection.find_one({"_id": ObjectId(new_task.inserted_id)})
            return (inputted_task, 200, None)

        error_msg = {'error': 'invalid parameters'}
        json_error_msg = json.dumps(error_msg)
        return (json_error_msg, 400, None)

    @authenticated_request
    def patch(self):
        task_collection = app.db.Tasks
        changing_properties = request.json
        selected_task = request.args
        auth = request.authorization
        target_task = task_collection.find_one({'user_email': auth['username']})
        if 'name' in selected_task:
            if changing_properties['completion_percentage'] != None:
                changed_task = task_collection.update_one({'name': selected_task['name'], 'user_email': auth['username']}, {'$set': {'completion_percentage': changing_properties['completion_percentage']}})
                return ({"success": "You have successfully updated " + str(task_collection.find_one({'name': selected_task['name'], 'email': auth['username']}))}, 200, None)

    @authenticated_request
    def delete(self):
        task_collection = app.db.Tasks
        task = request.args
        user = request.authorization
        if 'name' in task:
            selected_task = task_collection.find_one({'user_email': user['username'], 'name': task['name']})
            if selected_task != None:
                task_collection.delete_one({'user_email': user['username'], 'name': task['name']})
                return ({"success": "You have successfully deleted " + str(task_collection.find_one({'name': task['name'], 'email': user['username']}))}, 200, None)
            not_found_msg = {'error': 'task not found'}
            json_not_found = json.dumps(not_found_msg)
            return (json_not_found, 400, None)



api.add_resource(Monster, '/monsters')
api.add_resource(User, '/users')
api.add_resource(Task, '/tasks')
api.add_resource(Friends, '/friends')
api.add_resource(Friend_Monsters, '/friends_monsters')

@api.representation('application/json')
def output_json(data, code, headers=None):
    resp = make_response(JSONEncoder().encode(data), code)
    resp.headers.extend(headers or {})
    return resp

if __name__ == '__main__':
    # Turn this on in debug mode to get detailled information about request
    # related exceptions: http://flask.pocoo.org/docs/0.10/config/
    app.config['TRAP_BAD_REQUEST_ERRORS'] = True
    app.run(debug=True)
