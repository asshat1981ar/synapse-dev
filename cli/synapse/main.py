import typer
app = typer.Typer(help="Synapse AI App-Builder CLI")

@app.command()
def new(name: str, template: str = "rag"):
    typer.echo(f"Scaffolding '{name}' with template '{template}' (stub)")

@app.command()
def doctor():
    typer.echo("Env OK (stub)")

if __name__ == "__main__":
    app()
