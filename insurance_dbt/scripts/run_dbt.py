import os
import subprocess
import logging
import argparse
import datetime

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(f"logs/dbt_run_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.log"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

def run_dbt_command(command, project_dir):
    """Run a dbt command and log the output"""
    logger.info(f"Running command: dbt {command}")
    
    try:
        process = subprocess.Popen(
            f"dbt {command}",
            shell=True,
            cwd=project_dir,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True
        )
        
        for line in process.stdout:
            logger.info(line.strip())
        
        process.wait()
        
        if process.returncode != 0:
            for line in process.stderr:
                logger.error(line.strip())
            logger.error(f"dbt command failed with return code {process.returncode}")
            return False
        
        logger.info(f"dbt command completed successfully")
        return True
    
    except Exception as e:
        logger.exception(f"Error running dbt command: {str(e)}")
        return False

def main():
    parser = argparse.ArgumentParser(description='Run dbt commands')
    parser.add_argument('--project-dir', default=os.getcwd(), help='dbt project directory')
    parser.add_argument('--profile', default='dev', help='dbt profile to use')
    parser.add_argument('--models', default=None, help='Specific models to run')
    parser.add_argument('--exclude', default=None, help='Models to exclude')
    parser.add_argument('--full-refresh', action='store_true', help='Perform full refresh')
    parser.add_argument('command', choices=['run', 'test', 'seed', 'docs', 'build'], help='dbt command to run')
    
    args = parser.parse_args()
    
    command = f"{args.command} --profile {args.profile}"
    
    if args.models:
        command += f" --select {args.models}"
    
    if args.exclude:
        command += f" --exclude {args.exclude}"
    
    if args.full_refresh and args.command in ['run', 'build']:
        command += " --full-refresh"
    
    os.makedirs("logs", exist_ok=True)
    
    success = run_dbt_command(command, args.project_dir)
    
    exit(0 if success else 1)

if __name__ == "__main__":
    main()