import json
import logging
import os

logger = logging.getLogger()
log_level = os.environ.get("log_level", logging.INFO)

logger.setLevel(log_level)
logger.info("Log level set to %s" % logger.getEffectiveLevel())

def lambda_handler(event, _):
    logger.debug(json.dumps(event))
    # agent = event['agent']
    actionGroup = event['actionGroup']
    function = event['function']
    # parameters = event.get('parameters', [])

    # Execute your business logic here. For more information, refer to: https://docs.aws.amazon.com/bedrock/latest/userguide/agents-lambda.html
    responseBody =  {
        "TEXT": {
            "body": "The function {} was called successfully!".format(function)
        }
    }

    action_response = {
        'actionGroup': actionGroup,
        'function': function,
        'functionResponse': {
            'responseBody': responseBody
        }

    }

    dummy_function_response = {'response': action_response, 'messageVersion': event['messageVersion']}
    logger.info("Response: {}".format(dummy_function_response))

    return dummy_function_response
